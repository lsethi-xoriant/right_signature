require 'helper'

describe RightSignature::Client::Users do

  after do
    RightSignature.setup_default_config
  end

  describe 'me', :vcr do
    it 'gets authenticated user details' do
      resp = rs_private_token_client.me
      expect(resp).to include_json(user: {})
      assert_requested :get, rs_api_url("me")
    end
  end
end
