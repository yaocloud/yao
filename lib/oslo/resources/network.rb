module Oslo::Resources
  class Network < RestfulResources
    self.service        = "network"
    self.resource_name  = "network"
    self.resources_name = "networks"
  end
end
