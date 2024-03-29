module Yao::Resources
  class FloatingIP < Base

    include PortAssociationable
    include ProjectAssociationable

    friendly_attributes :router_id, :description, :dns_domain, :dns_name,
                        :revision_number,
                        :floating_network_id, :fixed_ip_address,
                        :floating_ip_address,
                        :status, :port_details, :tags, :port_forwardings

    map_attributes_to_time :created_at, :updated_at
    alias :created :created_at
    alias :updated :updated_at

    self.service        = "network"
    self.resource_name  = "floatingip"
    self.resources_name = "floatingips"

    # @return [Yao::Resources::Router]
    def router
      @router ||= Yao::Router.get(router_id)
    end

    # @param [Yao::Resources::Port]
    # @return [Yao::Resources::FloatingIP]
    def associate_port(port)
      self.class.associate_port(id, port.id)
    end

    # @return [Yao::Resources::FloatingIP]
    def disassociate_port
      self.class.disassociate_port(id)
    end

    class << self

      # @param id [String] ID of floating_ip
      # @param port_id [String] ID of port
      # @return [Yao::Resources::FloatingIP]
      def associate_port(id, port_id)
        update(id, port_id: port_id)
      end

      # @param id [String] ID of floating_ip
      # @return [Yao::Resources::FloatingIP]
      def disassociate_port(id)
        update(id, port_id: nil)
      end
    end
  end
end
