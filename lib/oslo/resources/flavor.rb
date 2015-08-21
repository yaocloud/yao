module Oslo::Resources
  class Flavor < RestfulResources
    self.service        = "compute"
    self.resource_name  = "flavor"
    self.resources_name = "flavors"
  end
end
