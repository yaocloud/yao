module Yao
  module Resources
    module PortAssociationable

      def self.included(base)
        base.friendly_attributes :port_id
      end

      def port
        @port ||= Yao::Port.find(port_id)
      end
    end
  end
end
