module Yao::Resources
  class Flavor < Base
    friendly_attributes :name, :vcpus, :disk, :swap
    map_attribute_to_attribute "os-flavor-access:is_public" => :public?
    map_attribute_to_attribute "OS-FLV-DISABLED:disabled"   => :disabled?

    def ram(unit='M')
      case unit
      when 'M'
        self["ram"]
      when 'G'
        self["ram"] / 1024.0
      end
    end
    alias memory ram

    self.service        = "compute"
    self.resource_name  = "flavor"
    self.resources_name = "flavors"

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
