require 'faraday'
require 'faraday_middleware'

module RightSignature
  module Connection
    def get(path, query = {})
      request :get, path, query
    end

    def post(path, body)
      request :post, path, {}, body
    end

    private

    def request(method, path, query, body = nil)
      conn = Faraday.new(url: @api_endpoint, ssl: { verify: @ssl_verify }) do |http|
        if @access_token
          http.authorization :Bearer, @access_token
        elsif @private_api_token
          http.authorization :Basic, @private_api_token
        end

        http.request  :json
        http.response :json, content_type: /\bjson$/
        http.use      RightSignature::Response::RenderError
        http.adapter  Faraday.default_adapter
      end

      resp = conn.send(method) do |req|
        req.url path
        req.params = query
        req.body = body if body
        req.headers['Content-Type'] = 'application/json'
      end
      resp.body
    end
  end
end
