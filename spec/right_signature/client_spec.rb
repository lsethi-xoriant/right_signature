require 'helper'

describe RightSignature::Client do
  after do
    RightSignature.setup_default_config
  end

  describe 'a new client' do
    let(:subject) { RightSignature.client }
    it 'errors if an auth token has not been confgured' do
      expect do
        subject
      end.to raise_error(RightSignature::MissingAuthorizationTokenError, 'The client requires an authorization token.')
    end

    it 'errors if the api_endpoint is not configured' do
      RightSignature.api_endpoint = nil
      expect do
        subject
      end.to raise_error(RightSignature::ClientConfigurationError, 'The client requires a configured api_endpoint.')
    end

    it 'errors if there is a conflicting private and access token' do
      RightSignature.private_api_token = 'foo'
      RightSignature.access_token = 'foo'
      expect do
        subject
      end.to raise_error(RightSignature::ClientConfigurationError, 'The client cannot be configured with both an access and private token.')
    end

    it 'errors when ssl_verify is false when using the default endpoint' do
      RightSignature.configure do |rs|
        rs.access_token = 'foo'
        rs.ssl_verify = false
      end
      expect do
        subject
      end.to raise_error(RightSignature::ClientConfigurationError, 'The client requires ssl verification.')
    end

    it 'does not require ssl verification when not using the default endpoint' do
      RightSignature.configure do |rs|
        rs.access_token = 'foo'
        rs.api_endpoint = 'dev.rightsignature.com/something'
        rs.ssl_verify = false
      end

      expect { subject }.to_not raise_error
    end
  end
end
