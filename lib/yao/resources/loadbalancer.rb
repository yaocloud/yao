module Yao::Resources
  class LoadBalancer < Base
    friendly_attributes :provider, :description, :admin_state_up, :provisioning_status,
                        :vip_address, :operationg_status, :name

    map_attribute_to_resources listeners: LoadBalancerListener
    map_attribute_to_resources pools: LoadBalancerListener

    def project
      if project_id = self["project_id"]
        Yao::Tenant.find project_id
      end
    end
    alias :tenant :project

    def vip_network
      if vip_network_id = self["vip_network_id"]
        Yao::Network.find vip_network_id
      end
    end

    def vip_port
      if vip_port_id = self["vip_port_id"]
        Yao::Port.find vip_port_id
      end
    end

    def vip_subnet
      if vip_subnet_id = self["vip_subnet_id"]
        Yao::Subnet.find vip_subnet_id
      end
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "loadbalancer"
    self.resources_name = "loadbalancers"
    self.resources_path = "lbaas/loadbalancers"

    class << self
      alias :delete :destroy
    end
  end
end
