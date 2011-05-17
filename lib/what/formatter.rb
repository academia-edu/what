class What::Formatter
  def self.use(name)
    @formatter = case name
                 when 'json'
                   What::Formatters::JSON.new
                 when 'yaml'
                   What::Formatters::YAML.new
                 else
                   raise "Unknown formatter #{name}"
                 end
  end

  def self.mime
    @formatter.mime
  end

  def self.format(hash)
    @formatter.format(hash)
  end
end
