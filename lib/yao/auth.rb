require 'yao'
require 'json'
require 'time'

require 'yao/token'

module Yao
  %i(tenant_name username password).each do |name|
    Yao.config.param name, nil
  end

  module Auth
    class << self
      def try_new
        if Yao.config.tenant_name && Yao.config.username && Yao.config.password && Yao.default_client
          Yao::Auth.new
        end
      end

      def new(
          tenant_name: Yao.config.tenant_name,
          username: Yao.config.username,
          password: Yao.config.password
      )
        authinfo = {
          auth: {
            passwordCredentials: {
              username: username, password: password
            }
          }
        }
        authinfo[:auth][:tenantName] = tenant_name if tenant_name

        reply = Yao.default_client.default.post('/v2.0/tokens') do |req|
          req.body = authinfo.to_json
          req.headers['Content-Type'] = 'application/json'
        end

        body = reply.body["access"]

        token = Token.new(body["token"])
        token.register_endpoints(body["serviceCatalog"])
        return token
      end
    end
  end
end
