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
      authinfo[:tenantName] = tenant_name if tenant_name

      reply = Oslo::Client.conn.post('/v2.0/tokens') do |req|
        req.body = authinfo.to_json
        req.headers['Content-Type'] = 'application/json'
      end

      token = Token.new(reply.body["access"]["token"])
      return token
    end
  end

  class Token
    def initialize(token_data)
      @token = token_data["id"]
      @issued_at = Time.parse token_data["issued_at"]
      @expire_at = Time.parse token_data["expires"]
    end
    attr_accessor :token, :issued_at, :expire_at
    alias expires expire_at
  end
end
