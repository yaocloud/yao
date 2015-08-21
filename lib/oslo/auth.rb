require 'oslo'
require 'json'
require 'time'

module Oslo::Auth
  %i(tenant_name username password).each do |name|
    Oslo.config.param name, nil do |_|
      Oslo::Auth.try_new
    end
  end

  class << self
    def try_new
      if Oslo.config.tenant_name && Oslo.config.username && Oslo.config.password && Oslo.default_client
        Oslo::Auth.new
      end
    end

    def new(
        tenant_name: Oslo.config.tenant_name,
        username: Oslo.config.username,
        password: Oslo.config.password
    )
      authinfo = {
        auth: {
          passwordCredentials: {
            username: username, password: password
          }
        }
      }
      authinfo[:auth][:tenantName] = tenant_name if tenant_name

      reply = Oslo.default_client.default.post('/v2.0/tokens') do |req|
        req.body = authinfo.to_json
        req.headers['Content-Type'] = 'application/json'
      end

      body = reply.body["access"]

      token = Token.new(body["token"])
      token.register_endpoints(body["serviceCatalog"])
      return token
    end
  end

  class Token
    def initialize(token_data)
      @token = token_data["id"]
      @issued_at = Time.parse token_data["issued_at"]
      @expire_at = Time.parse token_data["expires"]

      @endpoints = {}
    end
    attr_accessor :token, :issued_at, :expire_at, :endpoints
    alias expires expire_at

    def register_endpoints(_endpoints)
      return unless _endpoints

      _endpoints.each do |endpoint_data|
        key = endpoint_data["type"]
        value = if d = endpoint_data["endpoints"].first
                  d["publicURL"]
                else
                  nil
                end
        if value
          @endpoints[key] = value
        end
      end
      Oslo.default_client.register_endpoints(@endpoints, token: @token)
    end
  end
end
