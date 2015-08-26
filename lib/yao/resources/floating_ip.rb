module Yao::Resources
  class FloatingIP < Base
    friendly_attributes :fixed_ip, :instance_id, :ip, :pool

    self.service        = "compute"
    self.resource_name  = "os-floating-ip"
    self.resources_name = "os-floating-ips"
  end
end
