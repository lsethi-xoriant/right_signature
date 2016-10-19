require 'faraday'

module RightSignature
  class Client
    module Token
      # https://tools.ietf.org/html/rfc6749#section-2.3
      #
      def revoke_token(access_token = nil)
        %w(access_token client_id client_secret).each do |required|
          unless instance_variable_get("@#{required}")
            raise RightSignature::OauthTokenError, "#{required} is required in order to revoke a token."
          end
        end

        conn = Faraday.new(url: token_endpoint, ssl: { verify: @ssl_verify }) do |http|
          http.request  :url_encoded
          http.use      RightSignature::Response::RenderError
          http.adapter  Faraday.default_adapter
        end
        conn.basic_auth(@client_id, @client_secret)
        conn.post do |req|
          req.url    'oauth/revoke'
          req.body = { token: access_token || @access_token }
        end
      end

      private

      def token_endpoint
        @api_endpoint.gsub(/public.*/, '')
      end
    end
  end
end
