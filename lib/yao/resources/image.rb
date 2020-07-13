require 'yao/resources/metadata_available'
module Yao::Resources
  class Image < Base
    friendly_attributes :name, :status, :progress, :metadata
    map_attribute_to_attribute minDisk: :min_disk
    map_attribute_to_attribute minRam: :min_ram

    # @param unit [String]
    # @return [Integer]
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

    self.service        = "image"
    self.api_version    = "v2"
    self.resource_name  = "image"
    self.resources_name = "images"

    extend MetadataAvailable

    class << self
      private

      # override Yao::Resources::RestfullyAccessible.resource_from_json
      # @param json [Hash]
      # @return [Yao::Resources::*]
      def resource_from_json(json)
        new(json)
      end
    end
  end
end
