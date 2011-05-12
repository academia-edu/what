class What::Modules::Processes < What::Modules::Base
  def initialize
    super
    @config.each do |name, regexp_str|
      @config[name] = Regexp.new(regexp_str)
    end
    @processes = {}
  end

  def check!
    @config.each do |name, regexp|
      @processes[name] = `ps aux`.split("\n").grep(regexp).map do |ln|
                           ln =~ /^\w+\s+(\d+).*(\d+:\d\d(?:\.\d\d)?) (.*)$/
                           {:pid => $1, :cpu_time => $2, :proctitle => $3.strip}
                         end
    end
  end

  def health
    all_ok = true
    @processes.each do |name, results|
      if results.count == 0
        all_ok = false
      end
    end
    all_ok ? :ok : :alert
  end

  def details
    @processes
  end
end

