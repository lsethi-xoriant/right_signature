module RightSignature
  module Default
    API_ENDPOINT = 'https://api.rightsignature.com/public/v1'.freeze
    SSL_VERIFY   = true

    def config_for(attr)
      const = attr.upcase
      const_get(const) if const_defined?(const)
    end

    module_function :config_for
  end
end
