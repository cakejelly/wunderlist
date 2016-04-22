module Wunderlist
  class Resource
    class << self
      def class_name
        name.split("::").last
      end

      def url
        "#{class_name.downcase}s"
      end

      def all(client, params = {})
        collection = client.get(url, params)
        collection.map{ |resource| new(resource, client) }
      end

      def find(client, id)
        response = client.get("#{url}/#{id}")
        new(response, client)
      end

      def create(client, payload = {})
        response = client.post(url, payload)
        new(response, client)
      end
    end

    attr_reader :attributes, :client

    def initialize(attributes, client)
      @attributes = attributes
      @client = client
    end
  end
end
