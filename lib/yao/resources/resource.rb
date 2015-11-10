require 'time'
module Yao::Resources
  class Resource < Base
    friendly_attributes :user_id, :resource_id, :project_id,
                        :last_sample_timestamp, :first_sample_timestamp,
                        :metadata,
                        :links

    def id
      resource_id
    end

    def tenant
      @tenant ||= Yap::User.get(project_id)
    end

    def user
      @user ||= Yap::User.get(user_id)
    end

    def last_sampled_at
      Time.parse last_sample_timestamp
    end

    def first_sampled_at
      Time.parse first_sample_timestamp
    end

    self.service        = "metering"
    self.api_version    = "v2"
    self.resources_name = "resources"

    class << self
      private
      def resource_from_json(json)
        json
      end

      def resources_from_json(json)
        json
      end
    end
  end
end
