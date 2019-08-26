module Yao
  module Resources
    module TenantAssociationable

      def self.included(base)
        base.friendly_attributes :tenant_id
      end

      def tenant
        Yao::Tenant.find tenant_id
      end
    end
  end
end
