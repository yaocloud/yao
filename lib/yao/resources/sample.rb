module Yao::Resources
  class Sample < Base
    friendly_attributes :id, :metadata, :meter,
                        :source, :type, :unit, :volume
                        :resouce_id, :tenant_id, :user_id

    def recorded_at
      Time.parse(self["recorded_at"])
    end

    def timestamp
      Time.parse(self["timestamp"])
    end

    def resource
      @resource ||= Yao::Resource.get(resource_id)
    end

    def tenant
      @tenant ||= Yao::Tenant.get(project_id)
    end

    def user
      @user ||= Yao::User.get(user_id)
    end

    self.service        = "metering"
    self.api_version    = "v2"
    self.resources_name = "samples"
  end
end
