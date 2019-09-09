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

  end
end
