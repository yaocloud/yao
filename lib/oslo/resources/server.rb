require 'oslo/resources/metadata_available'
module Oslo::Resources
  class Server < Base
    friendly_attributes :addresses, :metadata, :name, :progress,
                        :status, :tenant_id, :user_id, :key_name
    map_attribute_to_attribute :hostId => :host_id
    map_attribute_to_resource  :flavor => Flavor
    map_attribute_to_resource  :image  => Image
    map_attribute_to_resources :security_groups => SecurityGroup

    self.service        = "compute"
    self.resource_name  = "server"
    self.resources_name = "servers"

    extend MetadataAvailable
  end
end
