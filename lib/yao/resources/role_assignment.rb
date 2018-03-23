module Yao::Resources
  class RoleAssignment < Base
    friendly_attributes :scope, :role, :user
    self.service        = "identity"
    self.resource_name  = "role_assignment"
    self.resources_name  = "role_assignments"
    self.admin          = true
    self.api_version    = "v3"
    self.client.url_prefix = Yao.config.auth_url.gsub('v2.0', 'v3')

    def project
      @project ||= Yao::Tenant.get(scope["project"]["id"])
    end

    map_attribute_to_resource  role: Role
    map_attribute_to_resource  user: User
  end
end
