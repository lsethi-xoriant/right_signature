module RightSignature
  module Configuration
    class << self
      def keys
        @keys ||= %i(
          access_token
          client_id
          client_secret
          private_api_token
          api_endpoint
          ssl_verify
        )
      end
    end

    attr_accessor(*Configuration.keys)

    def configure
      yield self
    end

    def setup_default_config
      Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", RightSignature::Default.config_for(key))
      end
      self
    end

    def same_options?(opts)
      opts.hash == options.hash
    end

    private

    def options
      Hash[RightSignature::Configuration.keys.map { |key| [key, instance_variable_get(:"@#{key}")] }]
    end
  end
end
