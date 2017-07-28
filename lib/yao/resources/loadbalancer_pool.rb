require 'date'
module Yao::Resources
  class LoadBalancerPool < Base
    friendly_attributes :lb_algorithm, :protocol, :description,
                        :admin_state_up, :provisioning_status,
                        :session_persistence, :healthmonitor_id,
                        :operating_status, :name,

    def loadbalancers
      self["loadbalancers"].map do |loadbalancer|
        Yao::LoadBalancer.find loadbalancer["id"]
      end
    end

    def created_at
      Date.parse(self["created_at"])
    end

    def updated_at
      Date.parse(self["updated_at"])
    end

    def listeners
      self["listeners"].map do |listener|
        Yao::LoadBalancerListener.find listener["id"]
      end
    end

    def project
      Yao::Tenant.find self["project_id"]
    end

    def members
      self["members"].map do |member|
        Yao::LoadBalancerPoolMember.find(self,member["id"])
      end
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "pool"
    self.resources_name = "pools"
    self.resources_path = "lbaas/pools"
  end
end
