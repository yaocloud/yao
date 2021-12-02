require 'date'

module Yao::Resources
  class Aggregates < Base
    friendly_attributes :availability_zone, :deleted, :hosts, :metadata, :name

    # @return [Date]
    def deleted_at
      Date.parse(self["deleted_at"]) if self["deleted_at"]
    end

    self.service        = "compute"
    self.resources_name = "aggregates"
    self.resources_path = "os-aggregates"
  end
end
