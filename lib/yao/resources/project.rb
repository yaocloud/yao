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
      @servers ||= Yao::Server.list(all_tenants: 1, project_id: id)
    end

    def ports
      @ports ||= Yao::Port.list(tenant_id: id)
    end

    class << self
      def accessible
        as_member { self.list }
      end
    end
  end
end
