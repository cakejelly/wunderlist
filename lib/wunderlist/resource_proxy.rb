module Wunderlist
  class ResourceProxy
    attr_reader :client, :base, :resource

    def initialize(client, base, resource)
      @client = client
      @base = base
      @resource = resource
    end

    def method_missing(method, *args, &block)
      @resource.public_send(method, *([client] + args), &block)
    end

    def respond_to_missing?(method, include_private = false)
      @resource.respond_to?(method) || super
    end
  end
end
