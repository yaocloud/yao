module Yao::Resources
  class RoleAssignment < Base
    friendly_attributes :scope, :role, :user

    map_attribute_to_resource  role: Role
    map_attribute_to_resource  user: User

    self.service        = "identity"
    self.resource_name  = "role_assignment"
    self.resources_name  = "role_assignments"
    self.admin          = true
    self.api_version    = "v3"

    # @return [Yao::Resources::Project]
    def project
      @project ||= Yao::Project.get(scope["project"]["id"])
    end

    class << self
      # @param _subpath [String]
      # @return [String]
      def create_url(_subpath='')
        resources_name
      end

      # @param query [Hash]
      def get(opt = {})
        query = {}

        if (user = opt[:user])
          query['user.id'] = resource_id_or_string(user)
        end

        if (project = opt[:project] || opt[:tenant])
          query['scope.project.id'] = resource_id_or_string(project)
        end

        list(query)
      end

      private
      def resource_id_or_string(item)
        if item.respond_to?(:id)
          item.id
        else
          item
        end
      end
    end
  end
end
