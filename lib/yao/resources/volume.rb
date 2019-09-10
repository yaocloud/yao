module Yao::Resources
  class Volume < Base
    friendly_attributes :name, :size, :volume_type

    map_attribute_to_attribute 'os-vol-tenant-attr:tenant_id' => :tenant_id

    self.service        = "volumev3"
    self.resource_name  = "volume"
    self.resources_name = "volumes"
    self.resources_detail_available = true
  end
end
