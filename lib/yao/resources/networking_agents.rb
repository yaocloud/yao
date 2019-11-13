module Yao::Resources
  class NetworkingAgents < Base

    friendly_attributes :admin_state_up, :agent_type, :alive,
                        :availability_zone, :binary, :configurations,
                        :description, :heartbeat_timestamp, :host,
                        :resources_synced, :topic

    self.service        = "network"
    self.resource_name  = "agents"
    self.resources_name = "agents"

    # @return [Date]
    def created_at
      Time.parse(self["created_at"])
    end

    # @return [Date]
    def started_at
      Time.parse(self["started_at"])
    end

    # @return [Date]
    def heartbeat_timestamp
      Time.parse(self["heartbeat_timestamp"])
    end

    alias :state :admin_state_up
  end
end
