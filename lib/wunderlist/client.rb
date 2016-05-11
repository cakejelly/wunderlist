module Wunderlist
  class Client
    BASE_URL = "https://a.wunderlist.com/api/v1"

    attr_reader :client_id, :access_token

    def initialize(client_id, access_token)
      @client_id = client_id
      @access_token = access_token
    end

    def get(url, params = {})
      make_request(:get, url, params)
    end

    def post(url, payload = {})
      make_request(:post, url, payload)
    end

    def patch(url, payload = {})
      make_request(:patch, url, payload)
    end

    def delete(url, payload = {})
      make_request(:delete, url, payload)
    end

    def make_request(method, url, payload = {}, headers = {})
      url = "#{BASE_URL}/#{url}"

      headers = default_headers.merge(headers)

      response = RestClient::Request.execute(
        method: method,
        url: url,
        payload: payload.to_json,
        headers: headers
      )
      response.empty? ? true : JSON.parse(response)
    rescue RestClient::Exception => e
      raise Wunderlist::Exception.from_response(e.http_code, e.http_body)
    end

    def default_headers
      {
        "X-Access-Token" => access_token,
        "X-Client-ID" => client_id,
        "Content-Type" => "application/json"
      }
    end

    def lists
      ResourceProxy.new(self, false, List)
    end

    def users
      ResourceProxy.new(self, false, User)
    end

    def webhooks
      ResourceProxy.new(self, false, Webhook)
    end

    def tasks
      ResourceProxy.new(self, false, Task)
    end

    def subtasks
      ResourceProxy.new(self, false, Subtask)
    end
  end
end
