module What
  class Monitor
    # don't worry, this method name is ironic
    def go!
      # For now, use a hash as the centralized collection point for data. We
      # can't use a method on the module because Celluloid will block that call
      # until after whatever method is currently running, which could be
      # unacceptably slow. We could use a fancy thread-safe data structure
      # instead of a hash, but the GIL means hash assignment and reading are
      # safe as long as we're on MRI.
      @results = {}
      @modules = Config['modules'].map do |config_hash|
        name     = Helpers.camelize(config_hash.delete('type'))
        klass    = Modules.const_get(name)
        instance = klass.new(config_hash, @results)
        {
          class: klass,
          config_hash: config_hash,
          module: instance,
          id: instance.identifier
        }
      end

      @modules.each do |mod|
        mod[:module].async.start_monitoring
      end
    end

    def status
      statuses = []
      healths = []

      @modules.each do |mod|
        status = @results[mod[:id]] || {"health" => nil}
        healths << status['health']
        statuses << status

        if status["error"]
          mod[:module].async.start_monitoring
        end
      end

      {"health" => Helpers.overall_health(healths), "details" => statuses}
    end
  end
end
