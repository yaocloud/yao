module Yao
  module Resources
    module NetworkAssociationable

      def self.included(base)
        base.friendly_attributes :network_id
      end

      # @return [Yao::Resources::Network]
      def network
        @tenant ||= Yao::Network.find(network_id)
      end
    end
  end
end
