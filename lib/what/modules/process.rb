module What
  class Modules::Process < Modules::Base
    def initialize_module
      @regexp = Regexp.new(@config['regexp'] || @name)
      @processes = []
    end

    def check!
      @processes = `ps aux`.split("\n").grep(@regexp).map do |ln|
                     ln =~ /^\w+\s+(\d+).*(\d+:\d\d(?:\.\d\d)?) (.*)$/
                     {'pid' => $1, 'cpu_time' => $2, 'proctitle' => $3.strip}
                   end
    end

    def health
      if @processes.count > 0
        'ok'
      else
        'alert'
      end
    end

    def details
      {'processes' => @processes}
    end
  end
end
