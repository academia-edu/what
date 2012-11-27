require 'what/config'

module What
  module Modules

    def self.default_modules_full_path
      File.join(File.dirname(__FILE__), 'modules')
    end

    def self.config_module_full_paths
      (Config['module_paths'] || []).map do |p|
        if p.match(%r(^/))
          p
        else
          File.join(Config['base'], p)
        end
      end
    end

    # load all modules defined in what/modules, in addition to any paths
    # specified in the config file.
    def self.load_all
      require 'what/modules/base'

      require_dir(self.default_modules_full_path)

      self.config_module_full_paths.each do |path|
        require_dir(path)
      end
    end

    def self.load_module(module_name)
      require 'what/modules/base'

      loaded = false

      short_module_name = module_name.sub(/\.rb$/, '')

      ([self.default_modules_full_path] + self.config_module_full_paths).each do |path|
        candidate = File.join(path, short_module_name)
        if File.exists?("#{candidate}.rb")
          loaded = require candidate
        end
      end

      loaded
    end

    private

    def self.require_dir(path)
      Dir[File.join(path, '*.rb')].each do |fn|
        require fn
      end
    end

  end
end
