
require 'what/modules'
require 'what/helpers'

module What
  class Monitor

    # don't worry, these method names are ironic

    def initialize(modules)
      @modules = modules.map do |mod|
        name = Helpers.camelize(mod.delete('type'))
        Modules.const_get(name).new(mod)
      end
    end

    def go!
      Thread.abort_on_exception = true
      @threads = @modules.collect do |mod|
        Thread.new do
          loop do
            mod.check!
            Thread.current[:status] = mod.status
            sleep mod.interval
          end
        end
      end
    end

    def do_it(interval)
      loop do
        statuses = []
        healths = []
        @threads.each do |th|
          if th[:status]
            healths << th[:status]['health']
            statuses << th[:status]
          end
        end
        yield Helpers.overall_health(healths), statuses
        sleep interval
      end
    end

    def self.go!
      monitor = new Config['modules']
      monitor.go!
      Thread.new do 
        monitor.do_it(Config['interval']) do |health, statuses|
          Status['health'] = health
          Status['details'] = statuses          
        end
      end
    end

  end
end
