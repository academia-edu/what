# FIXME: currently assumes the other servers are set to JSON
class What::Modules::What < What::Modules::Base
  def initialize
    super
    @config.each do |name, host|
      @config[name] = "http://#{host}:9428"
    end
    @whats = {}
  end

  def check!
    @config.map do |name, uri|
      curl = Curl::Easy.new(uri)
      curl.on_complete do |easy|
        @whats[name] = JSON.parse(easy.body_str)
      end
    end
  end

  def health
    all_ok = true
    @whats.each do |name, results|
      if results[:health] != :ok
        all_ok = false
      end
    end
    all_ok ? :ok : :alert
  end

  def details
    @whats
  end
end
