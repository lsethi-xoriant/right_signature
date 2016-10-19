require 'right_signature/client'
require 'right_signature/default'
require 'right_signature/configuration'

module RightSignature
  class << self
    include RightSignature::Configuration

    def client
      return @client if @client && @client.same_options?(options)
      @client = RightSignature::Client.new(options)
    end

    private

    def respond_to_missing?(method_name)
      client.respond_to?(method_name, false)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      end
      super
    end
  end
end

RightSignature.setup_default_config
