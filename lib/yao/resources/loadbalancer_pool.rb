module Yao::Resources
  class LoadBalancerPool < Base
    friendly_attributes :lb_algorithm, :protocol, :description,
                        :admin_state_up, :provisioning_status,
                        :session_persistence, :operating_status, :name

    map_attribute_to_resources loadbalancers: LoadBalancer
    map_attribute_to_resources listeners: LoadBalancerListener

    map_attributes_to_time :created_at, :updated_at
    alias :created :created_at
    alias :updated :updated_at

    # @return [Yao::Resources::LoadBalancerListener]
    def listeners
      @listeners ||= self["listeners"].map do |listener|
                       Yao::LoadBalancerListener.get(listener["id"])
                     end
    end

    # @return [Yao::Resources::Tenant]
    def project
      if project_id = self["project_id"]
        Yao::Tenant.find project_id
      end
    end
    alias :tenant :project

    # @return [Yao::Resources::LoadBalancerPoolMember]
    def members
      @members ||= self["members"].map do |member|
                     Yao::LoadBalancerPoolMember.get(self, member["id"])
                   end
    end

    # @return [Yao::Resources::LoadBalancerHealthMonitor]
    def healthmonitor
      @healthmonitor ||= if healthmonitor_id = self["healthmonitor_id"]
                           Yao::LoadBalancerHealthMonitor.get(healthmonitor_id)
                         end
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "pool"
    self.resources_name = "pools"
    self.resources_path = "lbaas/pools"
  end
end
