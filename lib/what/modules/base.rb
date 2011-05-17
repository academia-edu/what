module What
  class Modules::Base
    def initialize
      @config = if defined?(DEFAULTS)
                  DEFAULTS.merge(Config['module_config'][self.name] || {})
                else
                  Config['module_config'][self.name]
                end
    end

    def name
      Helpers.underscore(self.class.name.split('::').last)
    end

    def check!
    end

    def status
      { :health => health }.merge(details)
    end

    def health
      raise "Module #{self.class.name} doesn't override 'health'"
    end

    def details
      {}
    end
  end
end
