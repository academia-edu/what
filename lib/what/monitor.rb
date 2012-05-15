module What
  class Monitor
    # don't worry, these method names are ironic
    def self.go!
      @modules = Config['modules'].map do |mod|
        name = Helpers.camelize(mod.delete('type'))
        Modules.const_get(name).new(mod)
      end

      Thread.abort_on_exception = true
      @threads = @modules.collect do |mod|
        Thread.new do
          loop do
            mod.check!
            Thread.current[:status] = mod.status
            sleep Config['interval']
          end
        end
      end

      Thread.new { self.do_it }
    end

    def self.do_it
      Status['details'] = []
      loop do
        statuses = []
        healths = []
        @threads.each do |th|
          if th[:status]
            healths << th[:status]['health']
            statuses << th[:status]
          end
        end
        Status['health'] = Helpers.overall_health(healths)
        Status['details'] = statuses
        sleep Config['interval']
      end
    end
  end
end
