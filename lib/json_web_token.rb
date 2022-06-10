require 'net/http'
require 'uri'

class JsonWebToken
  def self.verify(token)
    options = {
      algorithm: 'RS256',
      iss: self.auth0_domain,
      verify_iss: true,
      aud: self.auth0_audience
      verify_aud: true
    }

    JWT.decode(token, nil, options) do |header|
      jwks_hash[header['kid']]
    end
  end

  def self.jwks_hash
    jwks_raw = Net::HTTP.get URI("https://#{self.auth0_domain}/.well-known/jwks.json")
    jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
    Hash[
      jwks_keys
        .map do |k|
          [
            k['kid'],
            OpenSSL::X509::Certificate.new(
              Base64.decode64(k['x5c'].first)
            ).public_key
          ]
        end
    ]
  end

  private

  def self.auth0_domain
    ENV.fetch('AUTH0_DOMAIN')
  end

  def self.auth0_audience
    ENV.fetch('AUTH0_AUDIENCE')
  end
end
