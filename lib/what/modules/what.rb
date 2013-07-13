# This module assumes the other servers are using the JSON formatter.
module What
  class Modules::What < Modules::Base
    def initialize_module
      @config.each do |name, host|
        @config[name] = "http://#{host}:9428"
      end
      @whats = {}
    end

    def check
      @config.map do |name, uri|
        body = open(uri).read
        @whats[name] = JSON.parse(body) rescue nil
      end
    end

    def health
      Helpers.overall_health(@whats.map { |_, attrs| attrs['health'] })
    end

    def details
      @whats
    end
  end
end
