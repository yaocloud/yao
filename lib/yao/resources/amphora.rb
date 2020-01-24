module Yao::Resources
  class Amphora < Base
    friendly_attributes :load_balancer_id, :compute_id, :lb_network_ip, :vrrp_ip, :ha_ip, :vrrp_port_id,
                        :ha_port_id, :role, :status, :vrrp_interface, :vrrp_id,
                        :vrrp_priority, :cached_zone, :image_id, :compute_flavor

    self.service        = "load-balancer"
    self.api_version    = "v2"
    self.resource_name  = "amphorae"
    self.resources_name = "amphorae"
    self.resources_path = "octavia/amphorae"
  end
end
