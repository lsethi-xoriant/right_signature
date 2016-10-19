require 'rspec'
require 'webmock/rspec'
require 'rspec/json_expectations'
require 'airborne'
require 'vcr'
require 'json'
require 'right_signature'

RSpec.configure(&:raise_errors_for_deprecations!)

VCR.configure do |c|
  c.default_cassette_options = {
    serialize_with: :json
  }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock

  c.filter_sensitive_data('{PRIVATE_API_TOKEN}') do
    ENV['RS_PRIVATE_API_TOKEN']
  end
  c.filter_sensitive_data('{ACCESS_TOKEN}') do
    ENV['RS_ACCESS_TOKEN']
  end
end

def rs_private_token_client
  RightSignature.configure do |rs|
    rs.private_api_token = ENV['RS_PRIVATE_API_TOKEN'] || 'test_token'
  end
  RightSignature
end

def rs_api_url(resource, params = nil)
  endpoint  = File.join(RightSignature::Default::API_ENDPOINT, resource)
  uri       = URI.parse(endpoint)
  uri.query = params.map{ |k,v| "#{k}=#{v}" }.join("&") if params
  uri.to_s
end
