module Yao::Resources
  module ServerUsageAssociationable
    # @param opt [Hash]
    # @return [Hash]
    def server_usage(params = {})
      path = "./os-simple-tenant-usage/#{id}"
      client = Yao.default_client.pool['compute']
      res = client.get(path, params, {"Accept" => "application/json"})
      res.body["tenant_usage"]
    end
  end
end
