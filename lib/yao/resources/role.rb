module Yao::Resources
  class Role < Base
    friendly_attributes :name, :id

    self.service        = "identity"
    self.resource_name  = "role"
    self.resources_name = "roles"
    self.resources_path = "/OS-KSADM/roles"
    self.admin          = true
  end
end
