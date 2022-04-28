require 'date'

module Yao::Resources
  class Aggregates < Base
    friendly_attributes :availability_zone, :deleted, :hosts, :metadata, :name

    map_attributes_to_time :created_at, :updated_at, :deleted_at
    alias :created :created_at
    alias :updated :updated_at

    self.service        = "compute"
    self.resources_name = "aggregates"
    self.resources_path = "os-aggregates"
  end
end
