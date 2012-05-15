module What
  class Modules::Base

    attr_reader :interval

    def initialize(params={})
      defaults = (self.class)::DEFAULTS rescue {}
      @name = params['name']
      @config = defaults.merge(params['config'] || {})
      @max = params['max'] || 'alert'
      # Use global interval setting if not set on a
      # per module basis
      @interval = params['interval'] || Config['interval']
      initialize_module
    end

    def initialize_module
    end

    def name
      Helpers.underscore(self.class.name.split('::').last)
    end

    def check!
    end

    def status
      status = {}
      status['name'] = @name if @name
      status['type'] = name # FIXME
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
  end
end
