class What::Server
  def initialize
    What::Modules.load_all
    What::Formatters.load_all
    What::Monitor.go!
  end

  def call(_)
    [
      What::Status[:health] != :alert ? 200 : 503,
      {'Content-Type' => What::Formatter.mime},
      What::Formatter.format(What::Status.all)
    ]
  end
end
