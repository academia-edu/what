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
      @got_response = true
    rescue Net::ReadTimeout => e
      @got_response = false
    end

    def health
      if !@got_response
        'alert'
      elsif @status != 200
        'alert'
      elsif @expect && @expect != @body
        'alert'
      else
        'ok'
      end
    end

    def details
      {
        'status' => @status,
        'last_response' => @body[0..200],
        'got_response' => @got_response
      }
    end
  end
end
