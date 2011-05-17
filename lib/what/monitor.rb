class What::Monitor
  # don't worry, these method names are ironic
  def self.go!
    @modules = Config['modules'].map do |m|
      name = Helpers.camelize(m)
      Modules.const_get(name).new
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
        Status[mod.name] = mod.status
      end
      Status[:health] = Helpers.overall_health(healths)
      sleep Config['interval']
    end
  end
end
