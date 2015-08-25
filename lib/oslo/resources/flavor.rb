module Oslo::Resources
  class Flavor < Base
    self.service        = "compute"
    self.resource_name  = "flavor"
    self.resources_name = "flavors"
  end
end
