module Yao::Resources
  class LoadBalancerPoolMember < Base
    friendly_attributes :monitor_port, :name, :weight,
                        :admin_state_up, :provisioning_status,
                        :monitor_address, :address,
                        :protocol_port, :operating_status

    # @return [Yao::Resources::Tenant]
    def project
      if project_id = self["project_id"]
        Yao::Tenant.find project_id
      end
    end
    alias :tenant :project

    # @return [Yao::Resources::Subnet]
    def subnet
      if subnet_id = self["subnet_id"]
        Yao::Subnet.find subnet_id
      end
    end

    self.service        = "load-balancer"
    self.api_version    = "v2.0"
    self.resource_name  = "member"
    self.resources_name = "members"

    class << self

      # @param pool [Yao::Resources::LoadBalancerPool]
      # @param query [Hash]
      # @return [Array<Yao::Resources::LoadBalancerPoolMember>]
      def list(pool, query={})
        self.resources_path = member_resources_path(pool)
        super(query)
      end

      # @param pool [Yao::Resources::LoadBalancerPool]
      # @param id_or_permalink [String]
      # @param query [Hash]
      # @return [Yao::Resources::LoadBalancerPoolMember]
      def get(pool, id_or_permalink, query={})
        self.resources_path = member_resources_path(pool)
        super(id_or_permalink, query)
      end
      alias find get

      # @param pool [Yao::Resources::LoadBalancerPool]
      # @param resource_params [Hash]
      # @return [Yao::Resources::LoadBalancerPoolMember]
      def create(pool, resource_params)
        self.resources_path = member_resources_path(pool)
        super(resource_params)
      end

      # @param pool [Yao::Resources::LoadBalancerPool]
      # @param id [String]
      # @param resource_params [Hash]
      # @return [Yao::Resources::LoadBalancerPoolMember]
      def update(pool, id, resource_params)
        self.resources_path = member_resources_path(pool)
        super(id, resource_params)
      end

      # @param pool [Yao::Resources::LoadBalancerPool]
      # @param id [String]
      # @return [String]
      def destroy(pool, id)
        self.resources_path = member_resources_path(pool)
        super(id)
      end

      private
      # @param pool [Yao::Resources::LoadBalancerPool]
      # @return [String]
      def member_resources_path(pool)
        "lbaas/pools/#{pool.id}/#{self.resources_name}"
      end
    end
  end
end
