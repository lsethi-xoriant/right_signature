module RightSignature
  class Error < StandardError
    def self.parse_errors(response_env)
      klass = case response_env[:status].to_i
         when 400 then RightSignature::BadRequestError
         when 404 then RightSignature::RecordNotFoundError
         when 401 then RightSignature::UnauthorizedError
         when 422 then RightSignature::UnprocessableEntityError
         when 500 then RightSignature::InternalServerError
      end

      if klass
        body          = JSON.parse(response_env[:body])
        error_keys    = %w(error error_description)
        errors        = body.values_at(*error_keys)

        klass.new errors.join(' ') if errors.any?
      end
    end
  end

  BadRequestError                = Class.new(Error)
  UnauthorizedError              = Class.new(Error)
  UnprocessableEntityError       = Class.new(Error)
  InternalServerError            = Class.new(Error)
  RecordNotFoundError            = Class.new(Error)

  MissingAuthorizationTokenError = Class.new(Error)
  ClientConfigurationError       = Class.new(Error)
  OauthTokenError                = Class.new(Error)
end
