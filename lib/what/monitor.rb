module What
  class Monitor
    # don't worry, these method names are ironic
    def self.go!
      @modules = Config['modules'].map do |mod|
        name = Helpers.camelize(mod.delete('type'))
        Modules.const_get(name).new(mod)
      end

      Thread.abort_on_exception = true
      @thread = Thread.new(@modules) { |modules| self.do_it(modules) }
    end

    def self.do_it(modules)
      Status['details'] = []
      loop do
        statuses = []
        healths = []
        modules.each do |mod|
          mod.check!
          healths << mod.status['health']
          statuses << mod.status
        end
        Status['health'] = Helpers.overall_health(healths)
        Status['details'] = statuses
        sleep Config['interval']
      end
    end
  end
end
