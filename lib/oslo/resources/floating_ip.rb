module Oslo::Resources
  class FloatingIP < Base
    self.service        = "compute"
    self.resource_name  = "os-floating-ip"
    self.resources_name = "os-floating-ips"
  end
end
