module What
  class Config
    DEFAULTS = {
      'interval'      => 10,
      'formatter'     => 'json',
      'configs'       => [],
      'module_paths'  => [],
      'modules'       => []
    }

    @config = {}

    def self.load(fn)
      load_primary(fn)
      load_secondary(@config['configs'])
    end

    def self.load_primary(fn)
      @config = DEFAULTS.merge(YAML.load_file(fn))
      @config['base'] ||= File.expand_path(File.dirname(fn))
      @loaded = true
    end

    def self.load_secondary(fns)
      return if !fns

      fns.each do |fn|
        path = if fn.match(%r(^/))
                 fn
               else
                 File.join(@config['base'], fn)
               end
        begin
          opts = YAML.load_file(path)
          @config.merge!(opts)
        rescue Exception => e
          puts "Error loading config file #{path}: #{e}"
        end
      end
    end

    def self.loaded?
      @loaded
    end

    def self.[](attr)
      @config[attr]
    end

    def self.[]=(attr, val)
      @config[attr] = val
    end

    def self.all
      @config
    end
  end
end
