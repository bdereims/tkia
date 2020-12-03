# Copyright (c) 2013 ablagoev
# Copyright 2018 VMware, Inc.
# SPDX-License-Identifier: MIT

require "fluent/plugin/output"
require_relative "http_client.rb"

module Fluent::Plugin
  class LogIntelligenceOutput < Output
    Fluent::Plugin.register_output('vmware_log_intelligence', self)

    config_param :endpoint_url, :string
    config_param :http_retry_statuses, :string, default: ''
    config_param :read_timeout, :integer, default: 60
    config_param :open_timeout, :integer, default: 60
    # config_param :use_ssl, :bool, :default => false
    config_param :verify_ssl, :bool, :default => true
    config_param :rate_limit_msec, :integer, :default => 0
    # Keys from log event whose values should be added as log message/text
    # to log-intelligence. Note these key/value pairs  won't be added as metadata/fields
    config_param :log_text_keys, :array, default: ["log", "message", "msg"], value_type: :string
    # Flatten hashes to create one key/val pair w/o losing log data
    config_param :flatten_hashes, :bool, :default => true
    # Seperator to use for joining flattened keys
    config_param :flatten_hashes_separator, :string, :default => "_"

    config_section :buffer do
      config_set_default :@type, "memory"
      config_set_default :chunk_keys, []
      config_set_default :timekey_use_utc, true
    end

    def initialize
      super
      require 'http'
      require 'uri'
    end

    def validate_uri(uri_string)
      unless uri_string =~ /^#{URI.regexp}$/
        fail Fluent::ConfigError, 'endpoint_url invalid'
      end

      begin
        @uri = URI.parse(uri_string)
      rescue URI::InvalidURIError
        raise Fluent::ConfigError, 'endpoint_url invalid'
      end
    end

    def retrieve_headers(conf)
      headers = {}
      conf.elements.each do |element|
        if element.name == 'headers'
          headers = element.to_hash
        end
      end
      headers
    end

    def shorten_key(key)
      # LINT doesn't allow some characters in field 'name'
      # like '/', '-', '\', '.', etc. so replace them with @flatten_hashes_separator
      key = key.gsub(/[\/\.\-\\]/,@flatten_hashes_separator).downcase
      key
    end

    def create_lint_event(record)
      flattened_records = {}
      merged_records = {}
      if @flatten_hashes
        flattened_records = flatten_record(record, [])
      else
        flattened_records = record
      end

      keys = []
      log = ''
      flattened_records.each do |key, value|
        begin
          next if value.nil?
          # LINT doesn't support duplicate fields, make unique names by appending underscore
          key = shorten_key(key)
          if keys.include?(key)
            value = merged_records[key] + " " + value
          end
          keys.push(key)
          key.force_encoding("utf-8")

        end
        if @log_text_keys.include?(key)
          if log != "#{value}"
            if log.empty?
              log = "#{value}"
            else
              log += " #{value}"
            end
          end
        else
          merged_records[key] = value
        end
      end
      merged_records["text"] = log

      if log == "\\n"
        {}
      else
        merged_records
      end
    end

    def flatten_record(record, prefix=[])
      ret = {}

      case record
      when Hash
        record.each do |key, value|
          if @log_text_keys.include?(key)
            ret.merge!({key.to_s => value})
          else
            ret.merge! flatten_record(value, prefix + [key.to_s])
          end
        end
      when Array
        record.each do |value|
          ret.merge! flatten_record(value, prefix)
        end
      else
        return {prefix.join(@flatten_hashes_separator) => record}
      end
      ret
    end
    def configure(conf)
      super
      validate_uri(@endpoint_url)

      @statuses = @http_retry_statuses.split(',').map { |status| status.to_i }
      @statuses = [] if @statuses.nil?

      @headers = retrieve_headers(conf)

      @http_client = Fluent::Plugin::HttpClient.new(
        @endpoint_url, @verify_ssl, @headers, @statuses,
        @open_timeout, @read_timeout, @log)
    end

    def start
      super
    end

    def shutdown
      super
      begin
        @http_client.close if @http_client
      rescue
      end
    end

    def write(chunk)
      @log.info('write(chunk) called')
      is_rate_limited = (@rate_limit_msec != 0 and not @last_request_time.nil?)
      if is_rate_limited and ((Time.now.to_f - @last_request_time) * 1000.0 < @rate_limit_msec)
        @log.info('Dropped request due to rate limiting')
        return
      end

      data = []
      chunk.each do |time, record|
        data << create_lint_event(record)
      end

      @last_request_time = Time.now.to_f
      @http_client.post(JSON.dump(data))
    end
  end
end

