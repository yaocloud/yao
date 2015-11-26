module Yao::Resources
  class OldSample < Base
    friendly_attributes :counter_name, :counter_type, :counter_unit, :counter_volume,
                        :message_id, :project_id, :resource_id, :timestamp, :resource_metadata, :user_id
                        :source

    def recorded_at
      Time.parse(self["recorded_at"] || self["timestamp"])
    end
    alias timestamp recorded_at

    def id
      meter_id
    end

    def resource
      @resource ||= Yao::Resource.get(resource_id)
    end

    def tenant
      @tenant ||= Yao::User.get(project_id)
    end

    def user
      @user ||= Yao::User.get(user_id)
    end

    self.service        = "metering"
    self.api_version    = "v2"

    # get /v2/meters/{id} returns samples!
    def self.list(id_or_url, query={})
      json = if id_or_url =~ /^https?:\/\//
               GET(id_or_url).body
             else
               GET("meters/#{id_or_url}", query).body
             end
      return_resources(json)
    end

    # TODO: implement `def self.create'
  end
end
