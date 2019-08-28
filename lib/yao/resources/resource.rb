require 'time'
module Yao::Resources
  class Resource < Base
    include TenantAssociationable

    friendly_attributes :user_id, :resource_id,
                        :last_sample_timestamp, :first_sample_timestamp,
                        :metadata,
                        :links

    def id
      resource_id
    end

    def user
      @user ||= Yao::User.get(user_id)
    end

    def last_sampled_at
      Time.parse last_sample_timestamp
    end

    def first_sampled_at
      Time.parse first_sample_timestamp
    end

    def get_meter(name)
      if link = links.find{|l| l["rel"] == name }
        Yao::Sample.list(link["href"])
      end
    end

    def meters
      links.map{|l| l["rel"] }.delete_if{|n| n == 'self' }
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
