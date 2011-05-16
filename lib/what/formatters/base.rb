class What::Formatters::Base
  def mime
    raise "Formatter #{self.class.name} doesn't override 'mime'"
  end

  def format(_)
    raise "Formatter #{self.class.name} doesn't override 'format'"
  end
end
