module What::Modules
  # load all modules defined in what/modules, in addition to any paths
  # specified in the config file.
  def self.load_all
    globs = [File.join(File.dirname(__FILE__), 'modules', '*.rb')]

    if What::Config['module_paths']
      What::Config['module_paths'].each do |module_path|
        globs << File.join(What::Config['base'], module_path, '*.rb')
      end
    end

    globs.each do |glob|
      Dir[glob].each do |fn|
        require fn
      end
    end
  end
end
