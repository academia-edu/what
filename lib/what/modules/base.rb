module What
  class Modules::Base
    include Celluloid

    attr_reader :interval

    def initialize(params, output)
      defaults = (self.class)::DEFAULTS rescue {}
      @name = params['name']
      @config = defaults.merge(params['config'] || {})
      @max = params['max'] || 'alert'
      # Use global interval setting if not set on a
      # per module basis
      @interval = params['interval'] || Config['interval']
      @output = output
      initialize_module
    end

    def initialize_module
    end

    def start_monitoring
      @output[identifier] = nil

      loop do
        check!
        @output[identifier] = status
        sleep interval
      end
    rescue Exception => e
      # stop looping -- the server will restart if necessary
      @output[identifier] = shared_status.merge(
        "health" => "alert",
        "error" => "#{e.class}: #{e.message}"
      )
    end

    def name
      Helpers.underscore(self.class.name.split('::').last)
    end

    # A unique identifier that we can use to match results up with this
    # specific instance. This is necessary because Celluloid weirds identity.
    def identifier
      object_id
    end

    def check!
    end

    def status
      status = shared_status
      status['health'] = if @max == 'ok' || health == 'ok'
                           'ok'
                         elsif @max == 'warning' || health == 'warning'
                           'warning'
                         else
                           'alert'
                         end
      status['details'] = details
      status
    end

    def health
      raise "Module #{self.class.name} doesn't override 'health'"
    end

    def details
      {}
    end

    def shared_status
      status = {}
      status['name'] = @name if @name
      status['type'] = name # FIXME
      status
    end
  end
end
