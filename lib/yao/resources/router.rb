module Yao::Resources
  class Router < Base
    include ProjectAssociationable

    friendly_attributes :name, :description, :admin_state_up, :status, :external_gateway_info,
                        :routes, :distributed, :ha, :availability_zone_hints, :availability_zones

    self.service        = 'network'
    self.resource_name  = 'router'
    self.resources_name = 'routers'

    # @return [bool]
    def enable_snat
      external_gateway_info["enable_snat"]
    end

    # @return [Array<Hash>]
    def external_fixed_ips
      external_gateway_info["external_fixed_ips"]
    end

    # @return [Yao::Resource::Network]
    def external_network
      @external_network ||= if network_id = external_gateway_info["network_id"]
                              Yao::Network.get(network_id)
                            end
    end

    # @return [Array<Yao::Resources::Port>]
    def interfaces
      Yao::Port.list(device_id: id)
    end

    class << self
      # @param id [String]
      # @param param [Hash]
      # @return [Hash]
      def add_interface(id, param)
        PUT(['routers', id, 'add_router_interface.json'].join('/'), param.to_json)
      end

      # @param id [String]
      # @param param [Hash]
      # @return [Hash]
      def remove_interface(id, param)
        PUT(['routers', id, 'remove_router_interface.json'].join('/'), param.to_json)
      end
    end
  end
end
