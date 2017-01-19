

# The [RightSignature Sharefile Edition](https://sharefile.rightsignature.com/) SDK Ruby Gem

A RightSignature Sharefile Edition client.

Design and philosophy inspired by [octokit](https://github.com/octokit/octokit.rb).

## Installation

```
# Install via Bundler
gem 'right_signature', git: 'git://github.com/rsig/right_signature.git'
```

## Configuration

* You can pass a configuration block to `RightSignature`.  Either an `access_token` or `private_api_token` is required for client authenticated requests.

```
RightSignature.configure do |r|
  r.private_api_token = "$token"

  # Optional
  r.client_id         = "$client_id"     
  r.client_secret     = "$client_secret"
  r.api_endpoint      = "https://api.rightsignature.com/public/v1"
end
```

* Alternatively you can assign configuration attributes without the block:

```
RightSignature.access_token = "$access_token"
```

## Examples

#### [Documents](https://api.rightsignature.com/developers/v1/documents.html)

```
# All documents
RightSignature.documents

# All Documents with paginated options
RightSignature.documents(page: 2, per_page: 5)

# All Documents filtered by a state
RightSignature.documents(state: "expired")

# Fuzzy searching
RightSignature.documents(search: "nda.pdf")

# All Documents created from a reusable template id
RightSignature.documents(template_id: "$template_id")

# Fetching a single Document
RightSignature.document("$document_id")

```

#### [Reusable Templates](https://api.rightsignature.com/developers/v1/reusable_templates.html)

```
# All Reusable Templates
RightSignature.reusable_templates

# All Reusable Templates with paginated options
RightSignature.reusable_templates(page: 2, per_page: 5)

# Fuzzy searching
RightSignature.reusable_templates(search: "founder-signer1")

# Fetching a single Reusable Template
RightSignature.reusable_template("$reusable_template_id")

# Sending a document from a reusable template
RightSignature.send_document("$reusable_template_id", name: "Agreement", expires_in: 10, roles: [{name: "signer1", signer_name: "Geoff", signer_email: "geoff@rightsignature.com"}], tags: {meetings: "q3", "new-hires": "hr"}, merge_field_values: [{id: "$merge_field_id", value: "Welcome to the team"}], passcode: {question: "secret", answer: "1234"}, shared_with: ["jev@rightsignature.com"], message: "Please sign this employee agreement.")
```

#### [Users](https://api.rightsignature.com/developers/v1/users.html)
```
# Fetch info about the authenticated user
RightSignature.me
```

####[Access Token Revocation](https://api.rightsignature.com/developers/v1/oauth_tokens/revoke.html)
* This requires a configured `client_id`, `client_secret`, and `access_token`.
* The client application must have ownership of the `access_token` that is being revoked.
* For security purposes the response will not return a status that indicates whether revocation was successful.  
```
RightSignature.revoke_token
```

#### Testing
* To record any new vcr cassettes you'll have to pass in a legitimate `private_api_token` as an environment variable.  This is filtered out in the resulting file.
  
  * `RS_PRIVATE_API_TOKEN=$token bundle exec rspec spec`

## Building locally

```
git clone git://github.com/rsig/right_signature.git
cd right_signature && bundle
gem build right_signature.gemspec  && gem install ./right_signature-0.0.1.gem
```
    
#### Gem Console

* There is a rake task, `rake console` which will configure `RightSignature` with the required configuration attributes and drop you in console.  You will need to create an `.env` file in the root of the project that includes the corresponding configuration secrets that are listed in the `Rakefile`

#### Work in progress
* The RightSignature for ShareFile API is in an early phase of development.