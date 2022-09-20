module Yao::Resources
  class ServerMigrate < Base
    friendly_attributes :dest_compute, :dest_host, :dest_node, :new_instance_type_id, :old_instance_type_id,
                        :source_compute, :source_node, :status, :migration_type, :uuid, :user_id, :project_id
    map_attributes_to_time :created_at, :updated_at

    self.service        = "compute"
    self.resource_name  = "migrations"
    self.resources_name = "os-migrations"

    # @return [String]
    def server_id
      self["server_uuid"] || self["instance_uuid"]
    end

    # @return [Yao::Resources::Server]
    def server
      @server ||= Yao::Server.get(server_id)
    end

    # @return [nil]
    def abort
      self.class.abort(server_id, id)
    end

    # @return [Array<Yao::Resources::ServerMigrate>]
    def self.get(id)
      path = ["servers", id, "migrations"].join("/")
      res = GET(path) do |req|
        req.headers["X-Openstack-Nova-Api-Version"] = "2.23"
      end
      resources_from_json(res.body)
    end

    # @return [nil]
    def self.destroy(server_id, id)
      path = ["servers", server_id, "migrations", id].join("/")
      pp path
      res = DELETE(path) do |req|
        req.headers["X-Openstack-Nova-Api-Version"] = "2.24"
      end
      res.body
    end

    class << self
      alias abort destroy
    end
  end
end
