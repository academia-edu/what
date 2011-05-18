module What
  class Server
    def initialize
      Modules.load_all
      Formatters.load_all
      Monitor.go!
    end

    def call(_)
      [
        Status['health'] != 'alert' ? 200 : 503,
        {'Content-Type' => Formatter.mime},
        Formatter.format(Status.all)
      ]
    end
  end
end
