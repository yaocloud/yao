require 'date'
module Yao::Resources
  class LoadBalancerPoolMember < Base
    friendly_attributes :monitor_port, :name, :weight,
                        :admin_state_up, :provisioning_status,
                        :monitor_address, :address,
                        :protocol_port, :operating_status

    def project
      Yao::Tenant.find self["project_id"]
    end

    def subnet
      Yao::Subnet.find self["subnet_id"]
    end

    def created_at
      Date.parse(self["created_at"])
    end

    def updated_at
      Date.parse(self["updated_at"])
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "member"
    self.resources_name = "members"

    class << self

      def list(pool, query={})
        self.resources_path = member_resources_path(pool)
        super(query)
      end

      def get(pool, id_or_permalink, query={})
        self.resources_path = member_resources_path(pool)
        super(id_or_permalink, query)
      end
      alias find get

      def create(pool, resource_params)
        self.resources_path = member_resources_path(pool)
        super(resource_params)
      end

      def update(pool, id, resource_params)
        self.resources_path = member_resources_path(pool)
        super(id, resource_params)
      end

      def destroy(pool, id)
        self.resources_path = member_resources_path(pool)
        super(id)
      end

      private
      def member_resources_path(pool)
        "lbaas/pools/#{pool.id}/#{self.resources_name}"
      end
    end
  end
end
