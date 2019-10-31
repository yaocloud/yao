module Yao::Resources
  class Meter < Base

    include TenantAssociationable

    friendly_attributes :meter_id, :name, :user_id, :resource_id, :source, :type, :unit

    def id
      meter_id
    end

    def resource
      @resource ||= Yao::Resource.get(resource_id)
    end

    def user
      @user ||= Yao::User.get(user_id)
    end

    self.service        = "metering"
    self.api_version    = "v2"
    self.resources_name = "meters"

    class << self
      private
      def resource_from_json(json)
        new(json)
      end

      def resources_from_json(json)
        json.map{|d| new(d)}
      end
    end
  end
end
