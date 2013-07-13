## Impletments the whatsch CLI for running modules from the command line

require 'what/config'
require 'what/modules'
require 'what/monitor'

module What
  class Ch

    def self.run(module_names, opts)
      new(module_names, opts).run
    end

    def initialize(module_names, opts)
      if opts.all && !Config.loaded?
        self.error "Use all: No config given to read for module names"
      end

      if 0 == module_names.size && !opts.all
        self.error "No module names given"
      end

      @modules = if What::Config.loaded?
                   if opts.all
                     What::Config['modules']
                   else
                     What::Config['modules'].select{|m| module_names.include?(m['name'])}
                   end
                 else
                   What::Config.set_defaults
                   module_names.uniq.map{|mn| {'type' => mn, 'name' => mn} }
                 end

      if 0 == @modules.size
        self.error "No modules to use"
      end

      @interval = (opts.interval || 10).to_i
    end

    def run
      @modules.each do |m|
        unless Modules.load_module(m['type'])
          self.error("Unknown module #{m['type']}")
        end
      end
      @monitor = Monitor.new(@modules)
      @monitor.go!
      @monitor.do_it(@interval) do |health, statuses|
        self.report health, statuses
      end
    end

    def report(health, statuses)
      $stdout.puts health
      $stdout.puts statuses.inspect
    end

    def error(message)
      $stderr.puts message
      exit(1)
    end

  end
end
