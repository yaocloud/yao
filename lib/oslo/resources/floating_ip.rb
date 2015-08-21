module Oslo::Resources
  class FloatingIP < RestfulResources
    self.service        = "compute"
    self.resource_name  = "os-floating-ip"
    self.resources_name = "os-floating-ips"
  end
end
