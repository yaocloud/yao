module Oslo::Resources
  class Hypervisor < Base
    self.service        = "compute"
    self.resource_name  = "os-hypervisor"
    self.resources_name = "os-hypervisors"
  end
end
