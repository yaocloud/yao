module Yao::Resources
  class Subnet < Base

    include NetworkAssociationable
    include ProjectAssociationable

    friendly_attributes :name, :cidr, :gateway_ip, :network_id, :ip_version,
                        :dns_nameservers, :host_routes, :enable_dhcp

    # @return [Array<Range>]
    def allocation_pools
      self["allocation_pools"].map do |pool|
        pool["start"]..pool["end"]
      end
    end

    alias dhcp_enabled? enable_dhcp

    self.service        = "network"
    self.resource_name  = "subnet"
    self.resources_name = "subnets"
  end
end
