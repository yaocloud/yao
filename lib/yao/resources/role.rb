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

      def list_for_user(user_name, on:)
        user   = Yao::User.get_by_name(user_name)
        tenant = Yao::Tenant.get_by_name(on)
        path = ["tenants", tenant.id, "users", user.id, "roles"].join("/")

        with_resources_path(path) { self.list }
      end

      def grant(role_name, to:, on:)
        role   = Yao::Role.get_by_name(role_name)
        user   = Yao::User.get_by_name(to)
        tenant = Yao::Tenant.get_by_name(on)

        PUT path_for_grant_revoke(tenant, user, role)
      end

      def revoke(role_name, from:, on:)
        role   = Yao::Role.get_by_name(role_name)
        user   = Yao::User.get_by_name(from)
        tenant = Yao::Tenant.get_by_name(on)

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
