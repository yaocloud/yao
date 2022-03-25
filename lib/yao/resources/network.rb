module Yao::Resources
  class Network < Base
    include ProjectAssociationable

    friendly_attributes :name, :status, :shared, :subnets, :admin_state_up
    map_attribute_to_attribute "provider:physical_network" => :physical_network
    map_attribute_to_attribute "provider:network_type"     => :type
    map_attribute_to_attribute "provider:segmentation_id"  => :segmentation_id

    alias shared? shared

    self.service        = "network"
    self.resource_name  = "network"
    self.resources_name = "networks"

    # @return [Array<Yao::Resources::Port>]
    def ports
      @ports ||= Yao::Port.list(network_id: id)
    end
  end
end
