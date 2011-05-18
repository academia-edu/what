module What
  class Modules::Unicorn < Modules::Base
    DEFAULTS = {
      'warning' => 1,
      'alert'   => 0
    }

    def initialize
      super
      @unicorns = []
    end

    def check!
      @unicorns = `ps aux`.split("\n").grep(/unicorn_rails worker/).map do |ln|
                    ln =~ /^\w+\s+(\d+).*(\d+:\d\d(?:\.\d\d)?) unicorn/
                    {'pid' => $1, 'cpu_time' => $2}
                  end
    end

    def health
      if @unicorns.count > @config['warning']
        'ok'
      elsif @unicorns.count > @config['alert']
        'warning'
      else
        'alert'
      end
    end

    def details
      {'workers' => @unicorns.count, 'details' => @unicorns}
    end
  end
end
