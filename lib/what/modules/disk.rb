module What
  class Modules::Disk < Modules::Base
    def initialize
      super
      @config.each do |name, config|
        if config.is_a?(Hash)
          @config[name] = {
            'warning' => config['warning'].to_i,
            'alert'   => config['alert'].to_i
          }
        else
          @config[name] = {
            'warning' => config.to_i,
            'alert'   => 100
          }
        end
      end
      @drives = {}
    end

    def check!
      @config.each do |name, config|
        ln = `df -h`.split("\n").grep(Regexp.new(name)).first
        if ln
          fields = ln.split(/\s+/)
          @drives[name] = {
            'size'     => fields[1],
            'used'     => fields[2],
            'avail'    => fields[3],
            'use%'     => fields[4].to_i,
            'warning%' => config['warning'],
            'alert%'   => config['alert']
          }
        else
          @drives[name] = nil
        end
      end
    end

    def health
      healths = @drives.map do |name, attrs|
                  puts name, attrs.inspect
                  if attrs.nil?
                    'alert'
                  elsif attrs['use%'] >= attrs['alert%']
                    'alert'
                  elsif attrs['use%'] >= attrs['warning%']
                    'warning'
                  else
                    'ok'
                  end
                end
      Helpers.overall_health(healths)
    end

    def details
      @drives
    end
  end
end
