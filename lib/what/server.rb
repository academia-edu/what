class What::Server
  def initialize
    What::Modules.load_all
    What::Monitor.go!
  end

  def call(_)
    [
      What::Status[:health] != :alert ? 200 : 503,
      {'Content-Type' => 'application/json'},
      JSON.unparse(What::Status.all) + "\n"
    ]
  end
end
