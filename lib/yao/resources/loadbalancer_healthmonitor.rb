require 'date'
module Yao::Resources
  class LoadBalancerHealthMonitor < Base
    friendly_attributes :name, :admin_state_up, :provisioning_status,
                        :delay, :expected_codes, :max_retries,
                        :http_method, :timeout, :max_retries_down,
                        :url_path, :type, :operating_status

    map_attribute_to_resources :pools     => LoadBalancerListener

    def created_at
      Date.parse(self["created_at"])
    end

    def updated_at
      Date.parse(self["updated_at"])
    end

    def project
      if project_id = self["project_id"]
        Yao::Tenant.find project_id
      end
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "healthmonitor"
    self.resources_name = "healthmonitors"
    self.resources_path = "lbaas/healthmonitors"
  end
end
