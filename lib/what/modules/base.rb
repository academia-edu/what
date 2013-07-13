module What
  class Modules::Base
    include Celluloid

    attr_reader :interval

    def initialize(params, output)
      defaults = (self.class)::DEFAULTS rescue {}
      @name = params['name']
      @config = defaults.merge(params['config'] || {})
      @max = params['max'] || 'alert'
      @interval = params['interval'] || Config['interval']
      @output = output
      @failures = 0
      initialize_module
    end

    def initialize_module
    end

    def start_monitoring
      @output[identifier] = nil

      loop do
        check
        @output[identifier] = status
        sleep interval
      end
    rescue Exception => e
      # stop looping -- the Monitor will restart if necessary
      @failures += 1
      output = shared_status.merge(
        "health" => "alert",
        "error" => "#{e.class}: #{e.message}",
        "failures" => @failures
      )
      puts "Error in module:\n#{YAML.dump(output)}"
      @output[identifier] = output
    end

    def name
      Helpers.underscore(self.class.name.split('::').last)
    end

    # A unique identifier that we can use to match results up with this
    # specific instance. This is necessary because Celluloid weirds identity.
    def identifier
      object_id
    end

    # This method should be overridden. The implementation here is for
    # backwards compatibility with older modules that implement check!
    # instead of check.
    def check
      check!
    end

    # This method must be overridden.
    def health
      raise "Module #{self.class.name} doesn't override 'health'"
    end

    # This method may be overridden, to provide extra details based on the
    # results of the check.
    def details
      {}
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

    def shared_status
      status = {}
      status['name'] = @name if @name
      status['type'] = name # FIXME
      status
    end
  end
end
