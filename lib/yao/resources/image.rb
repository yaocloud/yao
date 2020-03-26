require 'yao/resources/metadata_available'
module Yao::Resources
  class Image < Base
    friendly_attributes :name, :status, :progress, :metadata
    map_attribute_to_attribute minDisk: :min_disk
    map_attribute_to_attribute minRam: :min_ram

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

    # override Yao::Resources::Restfully_Accessible.get
    # @param id_or_name_or_permalink [Stirng]
    # @param query [Hash]
    # @return [Yao::Resources::*]
    def self.get(id_or_name_or_permalink, query={})
      super
      res = if id_or_name_or_permalink.start_with?("http://", "https://")
              GET(id_or_name_or_permalink, query)
            elsif uuid?(id_or_name_or_permalink)
              GET(create_url(id_or_name_or_permalink), query)
            else
              get_by_name(id_or_name_or_permalink, query)
            end

      new(res.body)
    end

    self.service        = "image"
    self.api_version    = "v2"
    self.resource_name  = "image"
    self.resources_name = "images"

    extend MetadataAvailable
  end
end
