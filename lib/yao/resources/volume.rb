require 'yao/resources/volume_action'

module Yao::Resources
  class Volume < Base
    include ProjectAssociationable

    friendly_attributes :attachments, :availability_zone, :bootable, :descriptions, :encrypted, :metadata, :multiattach, :name, :replication_status, :size, :snapshot_id, :status, :user_id, :volume_type
    alias :type :volume_type

    map_attribute_to_attribute 'os-vol-host-attr:host' => :host
    map_attribute_to_attribute 'os-vol-tenant-attr:tenant_id' => :tenant_id

    self.service        = "volumev3"
    self.resource_name  = "volume"
    self.resources_name = "volumes"
    self.resources_detail_available = true

    def status=(s)
      self.class.set_status(self.id, s)
      self['status'] = s
    end

    extend VolumeAction
  end
end
