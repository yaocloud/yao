module Yao
  module Resources
    module RouterAssociationable

      def self.included(base)
        base.friendly_attributes :router_id
      end

      def router
        @router ||= Yao::Router.find(router_id)
      end
    end
  end
end
