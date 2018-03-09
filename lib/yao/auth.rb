require 'json'
require 'time'

require 'yao/token'
require 'yao/tokenv3'

module Yao
  %i(tenant_name username password timeout client_cert client_key region_name
     identity_api_version user_domain_id user_domain_name project_domain_id project_domain_name).each do |name|
    Yao.config.param name, nil
  end

  module Auth
    class << self
      def try_new
        if Yao.config.tenant_name && Yao.config.username && Yao.config.password && Yao.default_client
          Yao::Auth.new
        end
      end

      def build_authv3_info(tenant_name, username, password,
                            user_domain_id, user_domain_name,
                            project_domain_id, project_domain_name)
          identity = {
            methods: ["password"],
            password: {
              user: { name: username, password: password }
            }
          }
          if user_domain_id
            identity[:password][:user][:domain] = { id: user_domain_id }
          elsif user_domain_name
            identity[:password][:user][:domain] = { name: user_domain_name }
          end

          scope = {
            project: { name: tenant_name }
          }
          if project_domain_id
            scope[:project][:domain] = { id: project_domain_id }
          elsif project_domain_name
            scope[:project][:domain] = { name: project_domain_name }
          end

          return {
            auth: {
              identity: identity,
              scope: scope
            }
          }
      end

      def build_auth_info(tenant_name, username, password)
          auth_info = {
            auth: {
              passwordCredentials: {
                username: username, password: password
              }
            }
          }
          auth_info[:auth][:tenantName] = tenant_name if tenant_name

          auth_info
      end

      def new(
          tenant_name: Yao.config.tenant_name,
          username: Yao.config.username,
          password: Yao.config.password,
          identity_api_version: Yao.config.identity_api_version,
          user_domain_id: Yao.config.user_domain_id,
          user_domain_name: Yao.config.user_domain_name,
          project_domain_id: Yao.config.project_domain_id,
          project_domain_name: Yao.config.project_domain_name
      )
        if identity_api_version.to_i == 3
          auth_info = build_authv3_info(tenant_name, username, password,
                                        user_domain_id, user_domain_name,
                                        project_domain_id, project_domain_name)
          issue = TokenV3.issue(Yao.default_client.default, auth_info)
        else
          auth_info = build_auth_info(tenant_name, username, password)
          issue = Token.issue(Yao.default_client.default, auth_info)
        end

        return issue
      end
    end
  end
end
