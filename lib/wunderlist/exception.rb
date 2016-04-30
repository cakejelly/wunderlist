module Wunderlist
  class Exception < StandardError
    def self.from_response(http_code, response)
      new(http_code, response)
    end

    attr_reader :http_code, :response

    def initialize(http_code, response)
      @http_code = http_code
      @response = response
      super(message)
    end

    def message
      "\n#{JSON.pretty_generate(parsed_response)}"
    end

    def parsed_response
      JSON.parse(response)
    end
  end
end
