module Wunderlist
  class User < Resource
    def self.me(client)
      response = client.get("user")
      new(response, client)
    end
  end
end
