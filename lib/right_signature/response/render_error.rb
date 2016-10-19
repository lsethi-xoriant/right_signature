require 'faraday'

module RightSignature
  module Response
    class RenderError < Faraday::Response::Middleware
      private

      def on_complete(response_env)
        raise @error if @error = RightSignature::Error.parse_errors(response_env)
      end
    end
  end
end
