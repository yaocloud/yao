module Yao::Resources
  class Host < Base
    friendly_attributes :host_name, :service, :zone

    self.service        = "compute"
    self.resource_name  = "os-hosts"
    self.resources_name = "os-hosts"
  end
end
