task :console do
  require 'irb'
  require 'irb/completion'
  require 'pry'
  require 'right_signature'
  require 'dotenv'

  Dotenv.load

  RightSignature.configure do |rs|
    rs.api_endpoint      = ENV['RS_API_ENDPOINT']
    rs.private_api_token = ENV['RS_PRIVATE_API_TOKEN']
    rs.client_id         = ENV['RS_CLIENT_ID']
    rs.client_secret     = ENV['RS_CLIENT_SECRET']
    rs.ssl_verify        = ENV['RS_SSL_VERIFY'] == 'true'
  end
  ARGV.clear
  IRB.start
end
