module Yao::Resources
  class Volume < Base
    friendly_attributes :name, :size, :volume_type

    map_attribute_to_attribute 'os-vol-tenant-attr:tenant_id' => :tenant_id

    self.service        = "volumev3"
    self.resource_name  = "volume"
    self.resources_name = "volumes"

    class << self

      # @param query [Hash]
      # @return [Array<Yao::Resources::Volume]
      def list_detail(query={})
        res = GET([resources_path, "detail"].join("/"), query)
        resources_from_json(res.body)
      end
    end
  end
end
