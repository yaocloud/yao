require 'date'
module Yao::Resources
  class LoadBalancerListener < Base
    friendly_attributes :description, :admin_state_up,
                        :protocol, :protocol_port, :provisioning_status,
                        :default_tls_container_ref, :insert_headers,
                        :operating_status, :sni_container_refs,
                        :l7policies, :name

    def project
      Yao::Tenant.find self["project_id"]
    end

    def loadbalancers
      self["loadbalancers"].map do |loadbalancer|
        Yao::LoadBalancer.get loadbalancer["id"]
      end
    end

    def created_at
      Date.parse(self["created_at"])
    end

    def updated_at
      Date.parse(self["updated_at"])
    end

    def default_pool
      Yao::LoadBalancerPool.find self["default_pool_id"]
    end
    alias pool default_pool

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "listener"
    self.resources_name = "listeners"
    self.resources_path = "lbaas/listeners"
  end
end
