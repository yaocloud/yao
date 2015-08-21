module Oslo::Resources
  class Subnet < RestfulResources
    self.service        = "network"
    self.resource_name  = "subnet"
    self.resources_name = "subnets"
  end
end
