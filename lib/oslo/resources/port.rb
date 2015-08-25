module Oslo::Resources
  class Port < Base
    self.service        = "network"
    self.resource_name  = "port"
    self.resources_name = "ports"
  end
end
