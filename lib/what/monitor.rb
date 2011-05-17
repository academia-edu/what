class What::Monitor
  # don't worry, these method names are ironic
  def self.go!
    @modules = What::Config['modules'].map do |m|
      name = What::Helpers.camelize(m)
      What::Modules.const_get(name).new
    end

    Thread.abort_on_exception = true
    @thread = Thread.new(@modules) { |modules| self.do_it(modules) }
  end

  def self.do_it(modules)
    loop do
      healths = []
      modules.each do |mod|
        mod.check!
        healths << mod.health
        What::Status[mod.name] = mod.status
      end
      What::Status[:health] = What::Helpers.overall_health(healths)
      sleep What::Config['interval']
    end
  end
end
