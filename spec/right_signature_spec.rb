require 'helper'

describe RightSignature do

  after do
    RightSignature.setup_default_config
  end

  describe '.setup_default_config' do
    subject { RightSignature.setup_default_config }

    it 'uses a default for api_endpoint' do
      RightSignature.api_endpoint = 'bar'
      subject
      expect(RightSignature.api_endpoint).to eq RightSignature::Default::API_ENDPOINT
    end

    it 'uses a default for ssl_verify' do
      RightSignature.ssl_verify = 'foo'
      subject
      expect(RightSignature.ssl_verify).to eq RightSignature::Default::SSL_VERIFY
    end

    it 'sets up defaults when instantiated' do
      expect(RightSignature).to receive(:setup_default_config)
      RightSignature
    end
  end

  describe 'client' do
    let(:api_endpoint) { 'https://this.endpoint' }

    it 'instantiates a new client with default options' do
      expect(RightSignature::Client).to receive(:new).with(
        client_id: nil,
        client_secret: nil,
        access_token: nil,
        private_api_token: nil,
        api_endpoint: 'https://api.rightsignature.com/public/v1',
        ssl_verify: true
)
      RightSignature.client
    end

    it 'does not instantiate a new client if the options are the same' do
      RightSignature.api_endpoint = api_endpoint
      expect(RightSignature::Client).to_not receive(:new)

      RightSignature.api_endpoint = api_endpoint
    end
  end

  describe 'dynamic methods' do
    it 'proxies unknown messages to the client' do
      RightSignature.access_token = 'foo'
      stub_request(:any, File.join(RightSignature.api_endpoint, 'me'))
      expect(RightSignature.client).to receive(:me)
      RightSignature.me
    end
  end
end
