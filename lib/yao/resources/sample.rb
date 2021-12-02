module Yao::Resources
  class Sample < Base
    friendly_attributes :id, :metadata, :meter,
                        :source, :type, :unit, :volume,
                        :resource_id, :user_id

    # @return [Date]
    def recorded_at
      Time.parse(self["recorded_at"])
    end

    # @return [Date]
    def timestamp
      Time.parse(self["timestamp"])
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
    self.resources_name = "samples"
  end
end
