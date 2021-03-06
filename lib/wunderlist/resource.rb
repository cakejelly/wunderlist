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
        url = self.url

        if params.any?
          query_params = params.collect{ |key, val| "#{key}=#{val}" }.join("&")
          url = "#{url}?#{query_params}"
        end

        collection = client.get(url)
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

      def update(client, id, payload = {})
        response = client.patch("#{url}/#{id}", payload)
        new(response, client)
      end

      def destroy(client, id, payload = {})
        query_params = payload.map{|key, val| "#{key}=#{val}"}.join("&")
        delete_url = "#{url}/#{id}?#{query_params}"
        client.delete(delete_url)
      end
    end

    attr_reader :attributes, :client

    def initialize(attributes, client)
      @attributes = attributes
      @client = client
    end

    def url
      "#{self.class.url}/#{id}"
    end

    def update(payload = {})
      payload.merge!(revision: revision)
      @attributes = client.patch(url, payload)
      true
    end

    def destroy
      client.delete("#{url}?revision=#{revision}")
    end

    def method_missing(method, *args, &block)
      method_key = method.to_s
      attributes.has_key?(method_key) ? attributes[method_key] : super
    end

    def respond_to_missing?(method, include_private = false)
      method_key = method.to_s
      attributes.has_key?(method_key) ? true : false
    end
  end
end
