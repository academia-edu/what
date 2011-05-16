class What::Formatters::YAML < What::Formatters::Base
  def mime
    'application/x-yaml'
  end

  def format(hash)
    hash.to_yaml
  end
end
