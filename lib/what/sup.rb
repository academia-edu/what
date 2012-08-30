require 'net/http'
require 'json'

## Impletments the whatsup CLI for querying what servers

module What
  class Sup

    LEVELS = ['unknown', 'ok', 'warning', 'alert']

    def self.run(opts)
      new(opts).run
    end

    def initialize(opts)
      @opts = opts
      @statuses = []
      @servers = if opts.servers.size > 0
                   opts.servers
                 else
                   ['127.0.0.1']
                 end
    end

    ##@@ TODO: Make this multi-threaded
    def fetch_statuses
      @servers.each do |s|
        @statuses << self.fetch_status(*s.split(':'))
      end
    end

    def fetch_status(host, port='9428')      
      status = { 'host' => host, 'health' => 'unknown', 'oks' => [], 'warnings' => [], 'alerts' => [] }
      begin
        response = JSON.parse(Net::HTTP.get(host, '/', port))
        #status['details'] = response['details']
        response['details'].each do |d|
          if LEVELS.index(d['health']) > LEVELS.index(status['health'])
            status['health'] = d['health']
          end
          status["#{d['health']}s"] << [d['type'], d['details']]
        end
      rescue
      end
      status
    end

    def print_status(status)
      sections_to_show = self.sections_to_show
      if !@opts.hide || sections_to_show.any?{|s| status[s[1]].size > 0} || (status['health'] == 'unknown')
        puts "#{status['host']} | #{status['health'].upcase}"
        puts
        sections_to_show.each do |s|
          print_status_section(s[1], status[s[1]])
        end
      end
    end

    def print_status_section(section, details)
      puts "  #{section}:"
      details.each do |d|
        puts "    #{d[0]}"
        puts "      #{d[1].inspect}"
      end
      puts
    end

    def sections_to_show
      sections = []
      if @opts.alerts
        sections << ['Alerts', 'alerts']
      end
      if @opts.warnings || @opts.oks
        sections << ['Warnings', 'warnings']
      end
      if @opts.oks
        sections << ['OKs', 'oks']
      end
      sections
    end


    def run
      self.fetch_statuses
      @statuses.each do |status|
        self.print_status(status)
      end
    end

  end
end
