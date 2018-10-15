module Yao::Resources
  class Volume < Base
    friendly_attributes :name, :size

    map_attribute_to_attribute 'os-vol-tenant-attr:tenant_id' => :tenant_id

    self.service        = "volumev3"
    self.resource_name  = "volume"
    self.resources_name = "volumes"

    class << self
      def list_detail(query={})
        return_resources(
            resources_from_json(
                GET([resources_path, "detail"].join("/"), query).body
            )
        )
      end
    end
  end
end
