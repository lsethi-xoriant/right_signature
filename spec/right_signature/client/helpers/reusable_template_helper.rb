RSpec.shared_examples "cloned document from reusable template" do |endpoint|
  it 'errors when an expiry is not incuded' do
    expect {
      rs_private_token_client.send(endpoint, reusable_template_id, body.except(:expires_in))
    }.to raise_error(RightSignature::UnprocessableEntityError, /An expires_in value between 1 and 60 days is required/)
  end

  it 'errors when roles are not included' do
    expect {
      rs_private_token_client.send(endpoint, reusable_template_id, body.except(:roles))
    }.to raise_error(RightSignature::UnprocessableEntityError, /Missing parameter roles/)
  end

  it 'errors when the name is not included' do
    expect {
      rs_private_token_client.send(endpoint, reusable_template_id, body.except(:name))
    }.to raise_error(RightSignature::UnprocessableEntityError, /Documents Name is required/)
  end

  it 'errors when the merge field value ids do not match' do
    body[:merge_field_values] = [{id: 'does-not-exist', value: 'nope'}]
    expect {
      rs_private_token_client.send(endpoint, reusable_template_id, body)
    }.to raise_error(RightSignature::UnprocessableEntityError, /Merge field ids do not match/)
  end

  it 'errors when the document does not exist' do
    expect {
      rs_private_token_client.send(endpoint, '123456789', body)
    }.to raise_error(RightSignature::RecordNotFoundError, /Record not found/)
  end
end
