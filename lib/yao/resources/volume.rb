module Yao::Resources
  class Volume < Base
    friendly_attributes :name, :size, :volume_type, :attachments, :availability_zone,
                        :description, :migration_status, :metadata, :status,
                        :volume_image_metadata

    map_attribute_to_attribute 'encrypted' => :encrypted?
    map_attribute_to_attribute 'multiattach' => :multiattach?
    map_attribute_to_attribute 'os-vol-tenant-attr:tenant_id' => :tenant_id
    map_attribute_to_attribute 'os-vol-host-attr:host' => :host

    alias :type :volume_type

    self.service        = "volumev3"
    self.resource_name  = "volume"
    self.resources_name = "volumes"
    self.resources_detail_available = true

    def bootable?
      self["bootable"] == "true" ? true : false
    end
  end
end
