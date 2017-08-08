module Yao::Resources
  class LoadBalancer < Base
    friendly_attributes :provider, :description, :admin_state_up, :provisioning_status,
                        :pools, :vip_address,
                        :operationg_status, :name

    def project
      Yao::Tenant.find self["project_id"]
    end

    def vip_network
      Yao::Network.find self["vip_network_id"]
    end

    def vip_port
      Yao::Port.find self["vip_port_id"]
    end

    def vip_subnet
      Yao::Subnet.find self["vip_subnet_id"]
    end

    def listeners
      self["listeners"].map do |listener|
        Yao::LoadBalancerListener.find listener["id"]
      end
    end

    def pools
      self["pools"].map do |pool|
        Yao::LoadBalancerPool.find pool["id"]
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
