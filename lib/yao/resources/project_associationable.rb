module Yao
  module Resources
    module ProjectAssociationable

      def self.included(base)
        base.friendly_attributes :project_id
        base.friendly_attributes :tenant_id
      end

      # @return [Yao::Resources::Project]
      def project
        @project ||= Yao::Project.find(project_id || tenant_id)
      end

      alias :tenant :project
    end
  end
end
