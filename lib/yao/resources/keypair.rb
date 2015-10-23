module Yao::Resources
  class Keypair < Base
    friendly_attributes :name, :public_key, :fingerprint

    self.service        = "compute"
    self.resource_name  = "os-keypair"
    self.resources_name = "os-keypairs"

    def self.list(query={})
      return_resources(GET(resources_name, query).body[resources_name_in_json].map{|r| r[resource_name_in_json] })
    end
  end
end
