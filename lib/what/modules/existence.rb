module What
  class Modules::Existence < Modules::Base
    DEFAULTS = {
      'paths' => []
    }

    def initialize_module
      @paths = {}
    end

    def check!
      @config['paths'].each do |path|
        if Dir[path].count == 0
          @paths[path] = false
        else
          @paths[path] = true
        end
      end
    end

    def health
      Helpers.overall_health(@paths.map { |k, v| v ? 'ok' : 'alert' })
    end

    def details
      @paths
    end
  end
end
