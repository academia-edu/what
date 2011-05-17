module What
  module Formatters
    def self.load_all
      # load all formatters defined in what/formatters, in addition to any paths
      # specified in the config file.
      require 'what/formatters/base'

      globs = [File.join(File.dirname(__FILE__), 'formatters', '*.rb')]

      if Config['formatter_paths']
        Config['formatter_paths'].each do |formatter_path|
          globs << File.join(Config['base'], formatter_path, '*.rb')
        end
      end

      globs.each do |glob|
        Dir[glob].each do |fn|
          require fn
        end
      end

      Formatter.use(Config['formatter'])
    end
  end
end
