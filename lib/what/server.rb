class What::Server
  def initialize
    What::Modules.load_all
    What::Monitor.go!
  end

  def call(_)
    [
      What::Status[:health] != :alert ? 200 : 503,
      {'Content-Type' => What::Config.formatter.mime},
      What::Config.formatter.format(What::Status.all)
    ]
  end
end
