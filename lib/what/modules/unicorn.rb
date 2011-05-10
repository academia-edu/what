class What::Modules::Unicorn < What::Modules::Base
  @unicorns = []

  def check!
    @unicorns = `ps aux`.split("\n").grep(/unicorn_rails worker/).map do |ln|
                  ln =~ /^\w+\s+(\d+).*(\d+:\d\d(?:\.\d\d)?) unicorn/
                  {:pid => $1, :cpu_time => $2}
                end
  end

  def health
    if @unicorns.count > 0
      :ok
    else
      :alert
    end
  end

  def details
    {:workers => @unicorns.count, :details => @unicorns}
  end
end
