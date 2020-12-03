require 'json'
require 'net/http'
require 'uri'
require 'fluent/plugin/output'

class Fluent::LoginsightHTTPOutput < Fluent::Plugin::Output
  class ConnectionFailure < StandardError; end

  Fluent::Plugin.register_output('loginsight_http', self)

  ### Connection Params ###
  config_param :scheme, :string, :default => 'http'
  # Loginsight Host ex. localhost
  config_param :host, :string,  :default => 'localhost'
  # In case we want to post to  multiple hosts
  #config_param :hosts, :string, :default => nil
  # Loginsight port ex. 9000. Default 80
  config_param :port, :integer, :default => 80
  # HTTP method
  # Loginsight api path ex. 'api/v1/events/ingest'
  config_param :path, :string, :default => 'api/v1/events/ingest'
  config_param :agent_id, :string, :default => '0'
  config_param :username, :string, :default => nil
  config_param :password, :string, :default => nil, :secret => true
  # Authentication nil | 'basic'
  config_param :authentication, :string, :default => nil

  # Set Net::HTTP.verify_mode to `OpenSSL::SSL::VERIFY_NONE`
  config_param :ssl_verify, :bool, :default => true
  config_param :ca_file, :string, :default => nil

  ### API Params ###
  # post | put
  config_param :http_method, :string, :default => :post
  # form | json
  config_param :serializer, :string, :default => :json
  config_param :request_retries, :integer, :default => 3
  config_param :request_timeout, :time, :default => 60
  config_param :open_timeout, :time, :default => 60
  config_param :max_batch_size, :integer, :default => 512000

  # Simple rate limiting: ignore any records within `rate_limit_msec`
  # since the last one.
  config_param :rate_limit_msec, :integer, :default => 0
  # Raise errors that were rescued during HTTP requests?
  config_param :raise_on_error, :bool, :default => false
  ### Additional Params
  config_param :include_tag_key, :bool, :default => true
  config_param :tag_key, :string, :default => 'tag'
  config_param :flatten_hashes, :bool, :default => true
  config_param :flatten_hashes_separator, :string, :default => "__"
  config_param :shorten_keys, :hash, value_type: :string, default:
    {
        '__':'_',
        'labels_environment':'env',
        'kubernetes_':'',
        'labels_':'',
        '_name':'',
        '_hash':'',
        'container_':'',
        'namespace_purpose':'purpose'
    }

  def initialize
    super
  end

  def configure(conf)
    super
    @ssl_verify_mode = @ssl_verify ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
    @auth = case @authentication
            when 'basic'
              :basic
            else
              :none
            end

    @last_request_time = nil
  end

  def start
    super
  end

  def shutdown
    super
  end

  def format_url()
    url = "#{@scheme}://#{host}:#{port}/#{path}/#{agent_id}"
    url
  end

  def set_header(req)
    if @serializer == 'json'
      set_json_header(req)
    end
    req
  end

  def set_json_header(req)
    req['Content-Type'] = 'application/json'
    req
  end

  def shorten_key(key)
    # LI doesn't allow some characters in field 'name'
    # like '/', '-', '\', '.', etc. so replace them with '_'
    key = key.gsub(/[\/\.\-\\]/,'_').downcase
    # shorten field names using provided shorten_keys parameters
    @shorten_keys.each do | match, replace |
       key = key.gsub(match.to_s,replace)
    end
    key
  end

  def create_loginsight_event(tag, time, record)
    flattened_records = {}
    if @flatten_hashes
      flattened_records = flatten_record(record, [])
    end
    flattened_records[@tag_key] = tag if @include_tag_key
    fields = []
    keys = []
    log = ''
    flattened_records.each do |key, value|
      begin
        next if value.nil?
        # If there is time information available, update time for LI. LI ignores
        # time if it is out of the error/adjusment window of 10 mins. in such
        # cases we would still like to preserve time info, so add it as event.
        if ['time', 'timestamp', '_SOURCE_REALTIME_TIMESTAMP', '__REALTIME_TIMESTAMP'].include?(key)
          time = value
        end
        # LI doesn't support duplicate fields, make unique names by appending underscore
        key = shorten_key(key)
        while keys.include?(key)
          key = key + '_'
        end
        keys.push(key)
        key.force_encoding("utf-8")
        # convert value to string if needed
        begin
          value = value.to_s if not value.instance_of?(String)
          value.force_encoding("utf-8")
        rescue Exception=>e
          $log.warn "force_encoding exception: " "#{e.class}, '#{e.message}', \n Request: #{key} #{record.to_json[1..1024]}"
          value = "Exception during conversion: #{e.message}"
        end
      end
      if ['log', 'message', 'msg'].include?(key)
        if log != "#{value}"
          if log.empty?
            log = "#{value}"
          else
            log += " #{value}"
          end
        end
      else
        # filter out reserved fields
        if not ['timestamp'].include?(key)
            fields << {"name" => key, "content" => value}
        end
      end
    end
    event = {
      "fields" => fields,
      "text" => log.gsub(/^$\n/, ''),
      "timestamp" => time
    }
    event
  end


  def flatten_record(record, prefix=[])
    ret = {}

    case record
      when Hash
        record.each { |key, value|
          ret.merge! flatten_record(value, prefix + [key.to_s])
        }
      when Array
        # Don't mess with arrays, leave them unprocessed
        ret.merge!({prefix.join(@flatten_hashes_separator) => record})
      else
        return {prefix.join(@flatten_hashes_separator) => record}
    end
    ret
  end


  def create_request(tag, time, record)
    url = format_url()
    uri = URI.parse(url)
    req = Net::HTTP.const_get(@http_method.to_s.capitalize).new(uri.path)
    set_body(req, tag, time, record)
    set_header(req)
    return req, uri
  end


  def send_request(req, uri)
    is_rate_limited = (@rate_limit_msec != 0 and not @last_request_time.nil?)
    if is_rate_limited and ((Time.now.to_f - @last_request_time) * 1000.0 < @rate_limit_msec)
      $log.info('Dropped request due to rate limiting')
      return
    end

    if @auth and @auth == 'basic'
      req.basic_auth(@username, @password)
    end
    begin
      retries ||= @request_retries
      response = nil
      @last_request_time = Time.now.to_f

      http_conn = Net::HTTP.new(uri.host, uri.port)
      # For debugging, set this
      #http_conn.set_debug_output($stdout)
      http_conn.use_ssl = (uri.scheme == 'https')
      if http_conn.use_ssl?
        http_conn.ca_file = @ca_file
      end
      http_conn.verify_mode = @ssl_verify_mode

      response = http_conn.start do |http|
        http.read_timeout = @request_timeout
        http.open_timeout = @open_timeout
        http.request(req)
      end
    rescue => e # rescue all StandardErrors
      # server didn't respond
      $log.warn "Net::HTTP.#{req.method.capitalize} raises exception: " \
         "#{e.class}, '#{e.message}', \n Request: #{req.body[1..1024]}"
      retry unless (retries -= 1).zero?
      raise e if @raise_on_error
    else
       unless response and response.is_a?(Net::HTTPSuccess)
          res_summary = if response
                           "Response Code: #{response.code}\n"\
                           "Response Message: #{response.message}\n" \
                           "Response Body: #{response.body}"
                        else
                           "Response = nil"
                        end
          $log.warn "Failed to #{req.method} #{uri}\n(#{res_summary})\n" \
             "Request Size: #{req.body.size} Request Body: #{req.body[1..1024]}"
       end #end unless
    end # end begin
  end # end send_request


  def send_events(uri, events)
    req = Net::HTTP.const_get(@http_method.to_s.capitalize).new(uri.path)
    event_req = {
      "events" => events
    }
    req.body = event_req.to_json
    set_header(req)
    send_request(req, uri)
  end
  
  
  def handle_records(tag, es)
    url = format_url()
    uri = URI.parse(url)
    events = []
    count = 0
    es.each do |time, record|
      new_event = create_loginsight_event(tag, time, record)
      new_event_size = new_event.to_json.size
      if new_event_size > @max_batch_size
          $log.warn "dropping event larger than max_batch_size: #{new_event.to_json[1..1024]}"
      else
        if (count + new_event_size) > @max_batch_size
          send_events(uri, events)
          events = []
          count = 0
        end
        count += new_event_size
        events << new_event
      end
    end
    if count > 0
      send_events(uri, events)
    end
  end


  def process(tag, es)
    handle_records(tag, es)
  end
end

