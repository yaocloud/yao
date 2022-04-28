module Yao::Resources
  class LoadBalancerListener < Base
    friendly_attributes :description, :admin_state_up,
                        :protocol, :protocol_port, :provisioning_status,
                        :default_tls_container_ref, :insert_headers,
                        :operating_status, :sni_container_refs,
                        :l7policies, :name

    map_attribute_to_resources loadbalancers: LoadBalancer

    map_attributes_to_time :created_at, :updated_at
    alias :created :created_at
    alias :updated :updated_at

    # @return [Yao::Resources::Tenant]
    def project
      if project_id = self["project_id"]
        Yao::Tenant.find project_id
      end
    end
    alias :tenant :project

    # @return [Yao::Resources::LoadBalancerPool]
    def default_pool
      if default_pool_id = self["default_pool_id"]
        Yao::LoadBalancerPool.find default_pool_id
      end
    end
    alias pool default_pool

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "listener"
    self.resources_name = "listeners"
    self.resources_path = "lbaas/listeners"
  end
end
