Gem::Specification.new do |s|
  s.name = 'right_signature'
  s.version = '0.0.1'
  s.date = '2016-10-15'
  s.summary = 'RightSignature For Sharefile SDK'
  s.description = 'RightSignature For Sharefile SDK'
  s.summary = 'RightSignature SDK'
  s.authors = ['Geoff Ereth']
  s.email = 'geoff.ereth@citrix.com'
  s.homepage = 'http://sharefile.rightsignature.com'
  s.files = %w(.document CONTRIBUTING.md LICENSE.md README.md Rakefile right_signature.gemspec)
  s.files += Dir.glob('lib/**/*.rb')
  s.files += Dir.glob('lib/**/**/*.rb')

  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.add_development_dependency 'bundler', '>= 1.12'
  s.required_ruby_version = '>= 2.2.4'
  s.required_rubygems_version = '>= 1.3.5'
  s.add_runtime_dependency 'faraday', '~> 0.8', '>= 0.8.0'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.10', '>= 0.10.0'
end
