module Yao::Resources
  class Resource < Base

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
