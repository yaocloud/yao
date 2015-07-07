require 'oslo'
require 'json'
require 'time'

module Oslo::Auth
  class << self
    def new(tenant_name: nil, username: nil, password: nil)
      authinfo = {
        auth: {
          passwordCredentials: {
            username: username, password: password
          }
        }
      }
      authinfo[:auth][:tenantName] = tenant_name if tenant_name

      reply = Oslo::Client.conn.post('/v2.0/tokens') do |req|
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
    end
  end
end
