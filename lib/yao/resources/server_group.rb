module Yao::Resources
  class ServerGroup < Base
    friendly_attributes :name, :poicies, :members, :metadata, :project_id, :user_id, :policy, :rules

    self.service        = "compute"
    self.resource_name  = "server_group"
    self.resources_name = "os-server-groups"
  end
end
