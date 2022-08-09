module Yao::Resources
  class ServerMigrate < Base
    friendly_attributes :dest_compute, :dest_host, :dest_node, :instance_uuid, :new_instance_type_id, :old_instance_type_id,
                        :source_compute, :source_node, :status, :migration_type, :uuid, :user_id, :project_id
    map_attributes_to_time :created_at, :updated_at

    self.service        = "compute"
    self.resource_name  = "migrations"
    self.resources_name = "os-migrations"

    def server
      @server ||= Yao::Server.get(self["instance_uuid"])
    end
  end
end
