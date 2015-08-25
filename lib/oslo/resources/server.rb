module Oslo::Resources
  class Server < Base
    self.service        = "compute"
    self.resource_name  = "server"
    self.resources_name = "servers"
  end
end
