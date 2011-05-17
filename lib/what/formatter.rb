class What::Formatter
  def self.use(name)
    @formatter = case name
                 when 'json'
                   Formatters::JSON.new
                 when 'yaml'
                   Formatters::YAML.new
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
