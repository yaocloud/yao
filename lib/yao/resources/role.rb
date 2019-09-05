module Yao::Resources
  class Role < Base
    friendly_attributes :name, :description, :id

    self.service        = "identity"
    self.resource_name  = "role"
    self.resources_name = "roles"

    if self.client.url_prefix .to_s =~ /v2\.0/
      self.resources_path = "/OS-KSADM/roles"
    end

    self.admin          = true

    class << self
      def get_by_name(name)
        self.list.find {|role| role.name == name }
      end
      alias find_by_name get_by_name

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

      def path_for_grant_revoke(tenant, user, role)
        ["tenants", tenant.id, "users", user.id, "roles", "OS-KSADM", role.id].join("/")
      end
    end
  end
end
