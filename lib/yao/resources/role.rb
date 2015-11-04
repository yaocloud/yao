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
    end
  end
end
