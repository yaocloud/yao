module Yao::Resources
  class Keypair < Base
    friendly_attributes :name, :public_key, :fingerprint

    self.service        = "compute"
    self.resource_name  = "os-keypair"
    self.resources_name = "os-keypairs"

    # os-keypairs API returns very complicated JSON.
    # For example.
    # {
    #   "keypairs": [
    #     {
    #       "keypair": {
    #          "fingerprint": "...",
    #        }
    #     },
    #     {
    #       "keypair": {
    #          "fingerprint": "...",
    #        }
    #     },
    #   ]
    #
    # @param query [Hash]
    # @return [Array<Yao::Resources::Keypairs>]
    def self.list(query={})
      res = GET(resources_name, query)
      res.body['keypairs'].map { |attribute|
        new(attribute['keypair'])
      }
    end
  end
end
