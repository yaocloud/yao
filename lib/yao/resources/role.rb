module Yao::Resources
  class Role < Base
    friendly_attributes :name, :description, :id

    self.service        = "identity"
    self.resource_name  = "role"
    self.resources_name = "roles"
    self.admin          = true

    class << self

      # override Yao::Resources::RestfullyAccessible#find_by_name
      # This is workaround of keystone versioning v2.0/v3.
      # @return [Array<Yao::Resources::Role>]
      def find_by_name(name, query={})
        if api_version_v2?
          list.select{|r| r.name == name}
        else
          super
        end
      end

      # override Yao::Resources::RestfullyAccessible#resources_path
      # This is workaround of keystone versioning v2.0/v3.
      # @return [String]
      def resources_path
        if api_version_v2?
          "OS-KSADM/roles"
        else
          resources_name
        end
      end

      # @param user_name [String]
      # @param on [String]
      # @return [Array<Yao::Resources::Role>]
      def list_for_user(user_name, on:)
        user   = Yao::User.get(user_name)
        tenant = if api_version_v2?
                   Yao::Tenant.find_by_name(on)
                 else
                   Yao::Project.get(on)
                 end
        path = ["tenants", tenant.id, "users", user.id, "roles"].join("/")

        with_resources_path(path) { self.list }
      end

      # @param role_name [String]
      # @param to: [String]
      # @param on: [String]
      # @return [Faraday::Response]
      def grant(role_name, to:, on:)
        role   = Yao::Role.get(role_name)
        user   = Yao::User.get(to)
        tenant = if api_version_v2?
                   Yao::Tenant.find_by_name(on)
                 else
                   Yao::Project.get(on)
                 end

        PUT path_for_grant_revoke(tenant, user, role)
      end

      # @param role_name [String]
      # @param from: [String]
      # @param on: [String]
      # @return [Faraday::Response]
      def revoke(role_name, from:, on:)
        role   = Yao::Role.get(role_name)
        user   = Yao::User.get(from)
        tenant = if api_version_v2?
                   Yao::Tenant.find_by_name(on)
                 else
                   Yao::Project.get(on)
                 end

        DELETE path_for_grant_revoke(tenant, user, role)
      end

      private

      # workaround of keystone versioning v2.0/v3
      # @return [Bool]
      def api_version_v2?
        client.url_prefix.to_s =~ /v2\.0/
      end

      def path_for_grant_revoke(tenant, user, role)
        ["tenants", tenant.id, "users", user.id, "roles", "OS-KSADM", role.id].join("/")
      end
    end
  end
end
