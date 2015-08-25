module Oslo::Resources
  class Subnet < Base
    friendly_attributes :name, :cidr, :gateway_ip, :network_id, :tenant_id, :ip_version,
                        :dns_nameservers, :host_routes, :enable_dhcp

    def allocation_pools
      self["allocation_pools"].map do |pool|
        pool["start"]..pool["end"]
      end
    end

    def network
      Oslo::Network.find network_id
    end

    alias dhcp_enabled? enable_dhcp

    self.service        = "network"
    self.resource_name  = "subnet"
    self.resources_name = "subnets"
  end
end
