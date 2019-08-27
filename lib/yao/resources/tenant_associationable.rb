module Yao
  module Resources
    module TenantAssociationable

      def self.included(base)
        base.friendly_attributes :project_id
        base.friendly_attributes :tenant_id
      end

      def tenant
        @tenant ||= Yao::Tenant.find(project_id || tenant_id)
      end

      alias :project :tenant
    end
  end
end
