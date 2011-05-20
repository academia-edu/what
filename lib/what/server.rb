module What
  class Server
    def initialize
      Modules.load_all
      Formatters.load_all
      Monitor.go!
    end

    def call(env)
      if Config['secret_token'] && Config['secret_token'] != env['QUERY_STRING']
        [403, {'Content-Type' => 'text/plain'}, "403 Forbidden\n"]
      else
        [
          Status['health'] != 'alert' ? 200 : 503,
          {'Content-Type' => Formatter.mime},
          Formatter.format(Status.all)
        ]
      end
    end
  end
end
