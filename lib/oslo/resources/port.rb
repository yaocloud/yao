module Oslo::Resources
  class Port < RestfulResources
    self.service        = "network"
    self.resource_name  = "port"
    self.resources_name = "ports"
  end
end
