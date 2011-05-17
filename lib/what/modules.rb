module What
  module Modules
    # load all modules defined in what/modules, in addition to any paths
    # specified in the config file.
    def self.load_all
      require 'what/modules/base'

      default_modules_path = File.join(File.dirname(__FILE__), 'modules')
      require_dir(default_modules_path)

      Config['module_paths'].each do |module_path|
        path = if module_path.match(%r(^/))
                 module_path
               else
                 File.join(Config['base'], module_path)
               end
        require_dir(path)
      end
    end

    private
      def self.require_dir(path)
        Dir[File.join(path, '*.rb')].each do |fn|
          require fn
        end
      end
  end
end
