module What
  class Modules::Disk < Modules::Base
    DEFAULTS = {
      'regexp' => '/$',
      'warning' => '90%',
      'alert'   => '99%'
    }

    def initialize_module
      @regexp = Regexp.new(@config['regexp'])
    end

    def check!
      line = `df -h`.split("\n").grep(@regexp).first
      @info = if line
                fields = line.split(/\s+/)
                {
                  'size'     => fields[1],
                  'used'     => fields[2],
                  'avail'    => fields[3],
                  'use%'     => fields[4].to_i,
                  'warning%' => @config['warning'].to_i,
                  'alert%'   => @config['alert'].to_i,
                  'regexp'   => @config['regexp']
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
  end
end
