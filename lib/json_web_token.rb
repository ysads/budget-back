# frozen_string_literal: true

require 'net/http'
require 'uri'

class JsonWebToken
  def self.verify(token)
    options = {
      algorithms: 'RS256',
      iss: auth0_domain,
      verify_iss: true,
      aud: auth0_audience,
      verify_aud: true,
    }

    JWT.decode(token, nil, true, options) do |header|
      jwks_hash[header['kid']]
    end
  end

  def self.jwks_hash
    jwks_raw = Net::HTTP.get(URI("#{auth0_domain}.well-known/jwks.json"))
    jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
    jwks_keys.to_h { |k| [k['kid'], public_key(k)] }
  end

  def self.public_key(key)
    OpenSSL::X509::Certificate.new(
      Base64.decode64(key['x5c'].first),
    ).public_key
  end

  def self.auth0_domain
    ENV.fetch('AUTH0_DOMAIN', 'domain')
  end

  def self.auth0_audience
    ENV.fetch('AUTH0_AUDIENCE', 'audience')
  end
end
