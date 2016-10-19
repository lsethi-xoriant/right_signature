require 'helper'

describe RightSignature::Default do

  describe 'config_for' do
    it 'returns the value of a default const' do
      expect(
        RightSignature::Default.config_for('api_endpoint')
      ).to eq(RightSignature::Default::API_ENDPOINT)
    end

    it 'returns nil if a default const does not exist' do
      expect(
        RightSignature::Default.config_for('access_token')
      ).to be_nil
    end
  end
end
