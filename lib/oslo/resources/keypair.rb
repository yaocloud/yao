module Oslo::Resources
  class Keypair < Base
    self.service        = "compute"
    self.resource_name  = "os-keypair"
    self.resources_name = "os-keypairs"

    def self.list
      super.map{|r| r[resource_name_in_json] }
    end
  end
end
