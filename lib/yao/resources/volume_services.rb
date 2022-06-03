module Yao::Resources
  class VolumeServices < Base

    friendly_attributes :binary, :disabled_reason, :host, :state, :status,
                        :frozen, :zone, :cluster, :replication_status,
                        :active_backend_id, :backed_state
    map_attributes_to_time :updated_at

    self.service        = "volumev3"
    self.resource_name  = "services"
    self.resources_name = "services"
  end
end
