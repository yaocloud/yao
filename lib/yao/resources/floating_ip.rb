module Yao::Resources
  class FloatingIP < Base

    include TenantAssociationable

    friendly_attributes :router_id, :description, :dns_domain, :dns_name,
                        :revision_number,
                        :floating_network_id, :fixed_ip_address,
                        :floating_ip_address, :port_id,
                        :status, :port_details, :tags, :port_forwardings

    self.service        = "network"
    self.resource_name  = "floatingip"
    self.resources_name = "floatingips"

    def router
      @router ||= Yao::Router.get(router_id)
    end

    def project
      @project ||= Yao::Tenant.get(project_id)
    end
    alias :tenant :project

    def port
      @port ||= Yao::Port.find(port_id)
    end
  end
end
