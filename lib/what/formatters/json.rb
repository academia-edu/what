class What::Formatters::JSON < What::Formatters::Base
  def mime
    'application/json'
  end

  def format(hash)
    JSON.unparse(hash) + "\n"
  end
end
