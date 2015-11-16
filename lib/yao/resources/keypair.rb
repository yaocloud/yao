module Yao::Resources
  class Keypair < Base
    friendly_attributes :name, :public_key, :fingerprint

    self.service        = "compute"
    self.resource_name  = "os-keypair"
    self.resources_name = "os-keypairs"

    def self.list(query={})
      return_resources(
        resources_from_json(GET(resources_name, query).body).map{|r| resource_params(r)}
      )
    end
  end
end
