require 'right_signature/connection'
require 'right_signature/configuration'
require 'right_signature/client/error'
require 'right_signature/response/render_error'

require 'right_signature/client/token'
require 'right_signature/client/users'
require 'right_signature/client/documents'
require 'right_signature/client/reusable_templates'

module RightSignature
  class Client
    include RightSignature::Connection
    include RightSignature::Configuration
    include RightSignature::Client::Users
    include RightSignature::Client::Token
    include RightSignature::Client::Documents
    include RightSignature::Client::ReusableTemplates

    def initialize(options = {})
      RightSignature::Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || RightSignature.instance_variable_get(:"@#{key}"))
      end

      unless @api_endpoint
        raise RightSignature::ClientConfigurationError, 'The client requires a configured api_endpoint.'
      end

      unless @access_token || @private_api_token
        raise RightSignature::MissingAuthorizationTokenError, 'The client requires an authorization token.'
      end

      if @private_api_token && @access_token
        raise RightSignature::ClientConfigurationError, 'The client cannot be configured with both an access and private token.'
      end

      if @api_endpoint == RightSignature::Default::API_ENDPOINT && !@ssl_verify
        raise RightSignature::ClientConfigurationError, 'The client requires ssl verification.'
      end
    end
  end
end
