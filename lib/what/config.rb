class What::Config
  @config = {}

  def self.load(fn)
    load_primary(fn)
    load_secondary(@config['configs'])
  end

  def self.load_primary(fn)
    @config = YAML.load_file(fn)
    @config['base'] ||= File.expand_path(File.dirname(fn))
    @loaded = true
  end

  def self.load_secondary(fns)
    return if !fns

    fns.each do |fn|
      path = if fn.match(/^\//)
               fn
             else
               File.join(@config['base'], fn)
             end
      @config.merge!(YAML.load_file(path))
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

  def self.formatter
    @formatter ||= case @config['formatter']
                   when 'json'
                     What::JsonFormatter.new
                   when 'yaml'
                     What::YamlFormatter.new
                   else
                     What::JsonFormatter.new
                   end
  end
end
