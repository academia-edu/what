module What
  class Status
    @status = {}

    def self.[](attr)
      @status[attr]
    end

    def self.[]=(attr, val)
      @status[attr] = val
    end

    def self.all
      @status
    end
  end
end
