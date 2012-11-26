## Impletments the whatsch CLI for running modules from the command line

require 'what/modules'

module What
  class Ch

    def self.run(modules, opts)
      new(modules, opts).run
    end

    def initialize(modules, opts)
      @modules = modules.uniq
      @opts = opts
      @interval = (opts.interval || 10).to_i
    end

    def run
      @modules.each do |m|
        unless Modules.load_module(m)
          self.error("Unknown module #{m}")
        end
      end
    end

    def error(message)
      $stderr.puts message
      exit(1)
    end

  end
end
