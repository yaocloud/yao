require 'yao'
require 'json'
require 'time'

require 'yao/token'

module Yao
  %i(tenant_name username password timeout).each do |name|
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
        auth_info = {
          auth: {
            passwordCredentials: {
              username: username, password: password
            }
          }
        }
        auth_info[:auth][:tenantName] = tenant_name if tenant_name

        return Token.issue(Yao.default_client.default, auth_info)
      end
    end
  end
end
