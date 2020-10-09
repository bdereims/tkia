
# Constructs a photon-based container that runs fluentd with fluent-plugin-vmware-loginsight installed.
#
# Based on the information provided in the installation guide (https://docs.fluentd.org/installation/install-by-gem).
# Where possible, versions of components match the ones specified in the official debian-based Dockerfile for fluentd:
# https://github.com/fluent/fluentd-docker-image/blob/master/v1.6/debian/Dockerfile
#
# All components are installed from the trusted photon repositories.

FROM photon:3.0-20200424

USER root

RUN tdnf distro-sync --refresh -y \
    && tdnf install -y \
    rubygem-fluentd-1.6.3 \
    # Transitive dependencies of fluent-plugin-kubernetes_metadata_filter-2.2.0
    # that are not automatically picked for some reason
    rubygem-concurrent-ruby-1.0.5 \
    rubygem-i18n-1.1.0 \
    #
    # Optional but used by fluentd
    rubygem-oj-3.3.10 \
    rubygem-async-http-0.48.2 \
    jemalloc-4.5.0 \
    #
    # Fluentd plugins
    rubygem-fluent-plugin-systemd-1.0.1 \
    rubygem-fluent-plugin-concat-2.4.0 \
    rubygem-fluent-plugin-kubernetes_metadata_filter-2.2.0 \
    rubygem-fluent-plugin-remote_syslog-1.0.0

RUN gem install fluent-plugin-detect-exceptions -v 0.0.13

RUN gem install fluent-plugin-docker_metadata_filter -v 0.1.3

RUN gem install fluent-plugin-multi-format-parser

RUN gem install fluent-plugin-prometheus -v 1.6.1

RUN ln -s /usr/lib/ruby/gems/2.5.0/bin/fluentd /usr/bin/fluentd \
    && mkdir -p /fluentd/etc /fluentd/plugins \
    && fluentd --setup /fluentd/etc \
    && rmdir /fluentd/etc/plugin

# Latest version of Log Insight and LINT output plugins
COPY plugins/out_vmware_loginsight.rb plugins/out_loginsight_http.rb plugins/http_client.rb plugins/out_vmware_log_intelligence.rb /fluentd/plugins/

# Make sure fluentd picks jemalloc
ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

# Standard fluentd ports
EXPOSE 24224 5140

ENTRYPOINT ["/usr/bin/fluentd"]
CMD ["--config", "/fluentd/etc/fluent.conf", "--plugin", "/fluentd/plugins"]
