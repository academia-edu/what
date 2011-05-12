class What::JsonFormatter
  def mime
    'application/json'
  end

  def format(hash)
    JSON.unparse(hash) + "\n"
  end
end

class What::YamlFormatter
  def mime
    'application/x-yaml'
  end

  def format(hash)
    hash.to_yaml
  end
end
