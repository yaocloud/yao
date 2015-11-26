module Yao::Resource
  class Sample < Base
    friendly_attributes :id, :metadata, :meter,
                        :source, :type, :unit, :volume

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

    self.service        = "samples"
    self.api_version    = "v2"

  end
end
