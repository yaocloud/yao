module Yao::Resources
  class Project < Base
    friendly_attributes :id, :name, :description, :enabled, :parent_id, :domain_id
    alias :enabled? :enabled

    self.service        = "identity"
    self.resource_name  = "project"
    self.resources_name = "projects"
    self.admin          = true

    def domain?
      @data["is_domain"]
    end

    def servers
      @servers ||= Yao::Server.list(project_id: id)
    end

    def meters
      @meters ||= Yao::Meter.list({'q.field' => 'project_id', 'q.op' => 'eq', 'q.value' => id})
    end

    def ports
      @ports ||= Yao::Port.list(tenant_id: id)
    end

    def meters_by_name(meter_name)
      meters.select{|m| m.name == meter_name}
    end

    class << self
      def accessible
        as_member { self.list }
      end
    end
  end
end
