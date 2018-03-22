module Yao::Resources
  class LoadBalancerPool < Base
    friendly_attributes :lb_algorithm, :protocol, :description,
                        :admin_state_up, :provisioning_status,
                        :session_persistence, :operating_status, :name

    map_attribute_to_resources :loadbalancers => LoadBalancer
    map_attribute_to_resources :listeners     => LoadBalancerListener

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
      if project_id = self["project_id"]
        Yao::Tenant.find project_id
      end
    end
    alias :tenant :project

    def members
      self["members"].map do |member|
        Yao::LoadBalancerPoolMember.find(self,member["id"])
      end
    end

    def healthmonitor
      if healthmonitor_id = self["healthmonitor_id"]
        Yao::LoadBalancerHealthMonitor.find healthmonitor_id
      end
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "pool"
    self.resources_name = "pools"
    self.resources_path = "lbaas/pools"
  end
end
