module Oslo::Resources
  class Server < RestfulResources
    self.service        = "compute"
    self.resource_name  = "server"
    self.resources_name = "servers"
  end
end
