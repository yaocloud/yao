module Yao::Resources
  class ComputeServices < Base
    friendly_attributes  :status, :binary, :host, :zone, :state, :disabled_reason, :forced_down

    self.service        = "compute"
    self.resources_name = "os-services"
  end
end