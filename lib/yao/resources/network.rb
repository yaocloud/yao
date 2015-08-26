module Yao::Resources
  class Network < Base
    friendly_attributes :name, :status, :shared, :tenant_id, :subnets, :admin_state_up
    map_attribute_to_attribute "provider:physical_network" => :physical_network
    map_attribute_to_attribute "provider:network_type"     => :type
    map_attribute_to_attribute "provider:segmentation_id"  => :segmentation_id

    alias shared? shared

    self.service        = "network"
    self.resource_name  = "network"
    self.resources_name = "networks"
  end
end
