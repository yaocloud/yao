require 'yao/resources/metadata_available'
module Yao::Resources
  class Image < Base
    friendly_attributes :name, :status, :progress, :metadata
    map_attribute_to_attribute :minDisk => :min_disk
    map_attribute_to_attribute :minRam  => :min_ram

    def size(unit=nil)
      size = self["OS-EXT-IMG-SIZE:size"]
      case unit
      when 'K'
        size / 1024.0
      when 'M'
        size / 1024.0 / 1024.0
      when 'G'
        size / 1024.0 / 1024.0 / 1024.0
      else
        size
      end
    end

    self.service        = "compute"
    self.resource_name  = "image"
    self.resources_name = "images"

    extend MetadataAvailable
  end
end
