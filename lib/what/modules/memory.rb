module What
  class Modules::Memory < Modules::Base
    DEFAULTS = {
      'warning' => '80%',
      'alert'   => '90%'
    }

    def check!
      fields = self.memory_details
      @info = if fields.size == 2
                {
                  'size'     => fields[0],
                  'used'     => fields[0] - fields[1],
                  'avail'    => fields[1],
                  'use%'     => ((1.0 - (fields[1].to_f / fields[0])) * 100).round,
                  'warning%' => @config['warning'].to_i,
                  'alert%'   => @config['alert'].to_i
                }
              end
    end

    def health
      if @info.nil?
        'alert'
      elsif @info['use%'] >= @info['alert%']
        'alert'
      elsif @info['use%'] >= @info['warning%']
        'warning'
      else
        'ok'
      end
    end

    def details
      @info
    end

    protected

    # [total, free]
    def memory_details
      if RUBY_PLATFORM.match 'darwin'
        line = `top -l 1 | grep PhysMem:`
        used = line.match(/(\d+)\D+?used/)[1].to_i
        free = line.match(/(\d+)\D+?free/)[1].to_i
        [used + free, free]
      else
        `cat /proc/meminfo`.split("\n")[0..1].map{|line| line.match(/(\d+)/)[1].to_i}
      end
    end

  end
end
