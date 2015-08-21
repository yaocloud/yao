module Oslo::Resources
  class Keypair < RestfulResources
    self.service        = "compute"
    self.resource_name  = "os-keypair"
    self.resources_name = "os-keypairs"
  end
end
