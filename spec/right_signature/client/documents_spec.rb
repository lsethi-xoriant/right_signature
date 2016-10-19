require 'helper'

describe RightSignature::Client::Documents do

  after do
    RightSignature.setup_default_config
  end

  describe 'documents', :vcr do
    it 'gets all documents' do
      resp = rs_private_token_client.documents
      expect(resp).to include_json(documents: [])
      assert_requested :get, rs_api_url('documents')
    end

    it 'filters with a search token' do
      resp = rs_private_token_client.documents(search: 'contracts')
      expect(resp).to include_json(documents: [])
      expect(resp['documents'].first['tags']).to eq({'contracts' => 'sample'})
      assert_requested :get, rs_api_url('documents', {search: 'contracts'})
    end

    it 'filters with a state' do
      resp = rs_private_token_client.documents(state: 'pending')
      expect(resp['documents'].first['state']).to eq('pending')
      assert_requested :get, rs_api_url('documents', {state: 'pending'})
    end

    context 'paginated results' do
      it 'filters by page' do
        resp = rs_private_token_client.documents(page: 2)
        expect(resp).to include_json(documents: [], meta: { total_pages: 1 })
        assert_requested :get, rs_api_url('documents', {page: 2})
      end

      it 'filters per_page' do
        resp = rs_private_token_client.documents(per_page: 2)
        expect(resp['documents'].length).to eq(2)
        assert_requested :get, rs_api_url('documents', {per_page: 2})
      end
    end

    context 'when invalid' do
      it 'errors when the state is incorrect' do
        expect {
          rs_private_token_client.documents(state: 'voltron')
        }.to raise_error(RightSignature::UnprocessableEntityError, /Invalid parameter 'state'/)
      end

      it 'errors when the page is not a number' do
        expect {
          rs_private_token_client.documents(page: 'page number 2')
        }.to raise_error(RightSignature::UnprocessableEntityError, /Must be a number/)
      end

      it 'errors when per_page is not a number' do
        expect {
          rs_private_token_client.documents(per_page: 'twenty')
        }.to raise_error(RightSignature::UnprocessableEntityError, /Must be a number/)
      end

      it 'errors when the template cannot be found' do
        expect {
          rs_private_token_client.documents(template_id: '97215')
        }.to raise_error(RightSignature::RecordNotFoundError, /not found/)
      end
    end
  end

  describe 'document', :vcr do
    let(:document_id) { 'f610796c-6f32-4df2-818f-e4d4c1ab0aac' }

    it 'gets a document' do
      resp = rs_private_token_client.document(document_id)
      expect(resp).to include_json(document: { id: document_id })
      assert_requested :get, rs_api_url(File.join('documents', document_id))
    end

    it 'errors when the document does not exist' do
      expect {
        rs_private_token_client.document('12345')
      }.to raise_error(RightSignature::RecordNotFoundError, /not found/)
    end
  end
end
