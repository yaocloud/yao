module Yao::Resources
  class Role < Base
    friendly_attributes :name, :description, :id

    self.service        = "identity"
    self.resource_name  = "role"
    self.resources_name = "roles"
    self.resources_path = "/OS-KSADM/roles"
    self.admin          = true

    class << self
      def get_by_name(name)
        self.list.find {|role| role.name == name }
      end
      alias find_by_name get_by_name

      def grant(role_name, to:, on:)
        role   = Yao::Role.get_by_name(role_name)
        user   = Yao::User.get_by_name(to)
        tenant = Yao::Tenant.get_by_name(on)

        client.put path_for_grant_revoke(tenant, user, role) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
      end

      def revoke(role_name, from:, on:)
        role   = Yao::Role.get_by_name(role_name)
        user   = Yao::User.get_by_name(from)
        tenant = Yao::Tenant.get_by_name(on)

        client.delete path_for_grant_revoke(tenant, user, role) do |req|
          req.headers['Content-Type'] = 'application/json'
        end
      end

      private

      def path_for_grant_revoke(tenant, user, role)
        ["tenants", tenant.id, "users", user.id, "roles", "OS-KSADM", role.id].join("/")
      end
    end
  end
end
