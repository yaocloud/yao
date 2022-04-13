module Yao::Resources
  class Flavor < Base
    friendly_attributes :name, :vcpus, :disk, :swap
    map_attribute_to_attribute "os-flavor-access:is_public" => :public?
    map_attribute_to_attribute "OS-FLV-DISABLED:disabled"   => :disabled?

    # @param unit [String]
    # @return [Integer]
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
    self.resources_detail_available = true

    class << self
      # override Yao::Resources::RestfullyAccessible#find_by_name
      # @return [Array<Yao::Resources::Role>]
      def find_by_name(name, query={})
        list(query).select do |flavor|
          flavor.name == name
        end
      end
    end
  end
end
