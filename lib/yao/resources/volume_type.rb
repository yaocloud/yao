module Yao::Resources
  class VolumeType < Base
    friendly_attributes :name, :description, :is_public

    self.service        = "volumev3"
    self.resource_name  = "volume_type"
    self.resources_name = "volume_types"
    self.resources_path = "types"
  end
end
