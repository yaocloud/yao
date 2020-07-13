module Yao::Resources
  class FloatingIP < Base

    include PortAssociationable
    include TenantAssociationable

    friendly_attributes :router_id, :description, :dns_domain, :dns_name,
                        :revision_number,
                        :floating_network_id, :fixed_ip_address,
                        :floating_ip_address,
                        :status, :port_details, :tags, :port_forwardings

    self.service        = "network"
    self.resource_name  = "floatingip"
    self.resources_name = "floatingips"

    # @return [Yao::Resources::Router]
    def router
      @router ||= Yao::Router.get(router_id)
    end

    # @return [Yao::Resources::Tenant]
    def project
      @project ||= Yao::Tenant.get(project_id)
    end
    alias :tenant :project
  end
end
