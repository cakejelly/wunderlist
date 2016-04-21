module Wunderlist
  class Client
    attr_reader :client_id, :access_token

    def initialize(client_id, access_token)
      @client_id = client_id
      @access_token = access_token
    end

    def make_request(method, url, payload = {}, headers = {})
      response = RestClient::Request.execute(
        method: method,
        url: url,
        payload: payload.to_json,
        headers: headers
      )
      response.empty? ? true : JSON.parse(response)
    rescue RestClient::Exception => e
      puts e
    end
  end
end
