require 'net/http'

module What
  class Modules::Http < Modules::Base
    def initialize_module
      @url = URI.parse @config['url']
      @expect = @config['expect'].strip if @config['expect']

      @status = -1
      @body = ''
    end

    def check
      resp = Net::HTTP.get_response(@url)
      @status = resp.code.to_i
      @body = resp.body.strip
    end

    def health
      if @status != 200
        'alert'
      elsif @expect && @expect != @body
        'alert'
      else
        'ok'
      end
    end

    def details
      { 'status' => @status, 'last_response' => @body[0..200] }
    end
  end
end
