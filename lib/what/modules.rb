require "what/config"

module What
  module Modules
    # Load all modules from any paths specified in the config file.
    def self.load_all
      config_module_full_paths.each do |path|
        require_dir(path)
      end
    end

    def self.config_module_full_paths
      paths = Config["module_paths"] || []

      paths.map do |path|
        path.include?("/") ? path : File.join(Config["base"], path)
      end
    end

    def self.require_dir(path)
      Dir[File.join(path, '*.rb')].each do |fn|
        require fn
      end
    end
  end
end

require "what/modules/base"
What::Modules.require_dir File.expand_path("../modules", __FILE__)
