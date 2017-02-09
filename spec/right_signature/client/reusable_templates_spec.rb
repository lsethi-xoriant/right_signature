require 'helper'
require_relative 'helpers/reusable_template_helper'

describe RightSignature::Client::ReusableTemplates do

  let(:reusable_template_id) { 'cfc4ff7d-cb18-486a-8f4a-c385c18623cc' }

  after do
    RightSignature.setup_default_config
  end

  describe 'reusable_templates', :vcr do
    it 'gets all reusable templates' do
      resp = rs_private_token_client.reusable_templates
      expect(resp).to include_json(reusable_templates: [])
      assert_requested :get, rs_api_url('reusable_templates')
    end

    it 'filters with a search token' do
      search_token = 'Nda'
      resp = rs_private_token_client.reusable_templates(search: search_token)
      expect(resp).to include_json(reusable_templates: [])
      expect(resp['reusable_templates'].first['name']).to eq(search_token)
      assert_requested :get, rs_api_url('reusable_templates', {search: search_token})
    end

    context 'paginated results' do
      it 'filters by page' do
        resp = rs_private_token_client.reusable_templates(page: 3)
        expect(resp).to include_json(reusable_templates: [])
        assert_requested :get, rs_api_url('reusable_templates', {page: 3})
      end

      it 'filters per_page' do
        resp = rs_private_token_client.reusable_templates(per_page: 1)
        expect(resp).to include_json(reusable_templates: [])
        assert_requested :get, rs_api_url('reusable_templates', {per_page: 1})
      end
    end

    context 'when invalid' do
      it 'errors when the page is not a number' do
        expect {
          rs_private_token_client.reusable_templates(page: 'page number 1')
        }.to raise_error(RightSignature::UnprocessableEntityError, /Must be a number/)
      end

      it 'errors when per_page is not a number' do
        expect {
          rs_private_token_client.reusable_templates(per_page: 'five')
        }.to raise_error(RightSignature::UnprocessableEntityError, /Must be a number/)
      end
    end
  end

  describe 'reusable_template', :vcr do
    it 'gets a reusable_template' do
      resp = rs_private_token_client.reusable_template(reusable_template_id)
      expect(resp).to include_json(reusable_template: { id: reusable_template_id })
      assert_requested :get, rs_api_url(File.join('reusable_templates', reusable_template_id))
    end

    it 'errors when the reusable template does not exist' do
      expect {
        rs_private_token_client.document('100')
      }.to raise_error(RightSignature::RecordNotFoundError, /not found/)
    end
  end

  context 'cloned documents from a reusable template' do
    let(:body) {
      {
        name: 'Nda',
        expires_in: 1,
        roles: [{name: 'signer1', signer_name: 'Geoff', signer_email: 'jev@rightsignature.com'}],
        merge_field_values: [{id: '4bc7aaa9-3ffe-4e65-bf5a-9b44d09113a1', value: '111 Jev St, Portland Oregon'}]
      }
    }
    describe 'send_document', :vcr do
      include_examples "cloned document from reusable template", :send_document

      it 'creates a document from a reusable template and returns a document' do
        resp = rs_private_token_client.send_document(reusable_template_id, body)
        expect(resp).to include_json(document: {})
        assert_requested :post, rs_api_url(File.join('reusable_templates', reusable_template_id, 'send_document'))
      end
    end

    describe 'embed_document' do
      include_examples "cloned document from reusable template", :embed_document

      it 'errows when the height is invalid'
      it 'errors when the width is invalid'
      it 'errors when the dimesions are not included'
      it 'returns a document with embed codes for each signer'
    end

  end
end
