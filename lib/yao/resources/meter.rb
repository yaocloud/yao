module Yao::Resources
  class Meter < Base

    include ProjectAssociationable

    friendly_attributes :meter_id, :name, :user_id, :resource_id, :source, :type, :unit

    # @return [String]
    def id
      meter_id
    end

    # @return [Yao::Resources::Resource]
    def resource
      @resource ||= Yao::Resource.get(resource_id)
    end

    # @return [Yao::Resources::User]
    def user
      @user ||= Yao::User.get(user_id)
    end

    self.service        = "metering"
    self.api_version    = "v2"
    self.resources_name = "meters"

    class << self
      private

      # override Yao::Resources::RestfullyAccessible.resource_from_json
      # @param json [Hash]
      # @return [Yao::Resources::Meter]
      def resource_from_json(json)
        new(json)
      end

      # override Yao::Resources::RestfullyAccessible.resources_from_json
      # @param json [Array<Hash>]
      # @return [Array<Yao::Resources::Meter>]
      def resources_from_json(json)
        json.map{|d| new(d)}
      end
    end
  end
end
