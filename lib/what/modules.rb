module What::Modules
  # load all modules defined in what/modules, in addition to any paths
  # specified in the config file.
  def self.load_all
    require 'what/modules/base'

    globs = [File.join(File.dirname(__FILE__), 'modules', '*.rb')]

    if Config['module_paths']
      Config['module_paths'].each do |module_path|
        globs << File.join(Config['base'], module_path, '*.rb')
      end
    end

    globs.each do |glob|
      Dir[glob].each do |fn|
        require fn
      end
    end
  end
end
