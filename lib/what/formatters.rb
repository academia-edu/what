module What::Formatters
  def self.load_all
    # load all formatters defined in what/formatters, in addition to any paths
    # specified in the config file.
    require 'what/formatters/base'

    globs = [File.join(File.dirname(__FILE__), 'formatters', '*.rb')]

    if What::Config['formatter_paths']
      What::Config['formatter_paths'].each do |formatter_path|
        globs << File.join(What::Config['base'], formatter_path, '*.rb')
      end
    end

    globs.each do |glob|
      Dir[glob].each do |fn|
        require fn
      end
    end

    What::Formatter.use(What::Config['formatter'])
  end
end
