module Yao::Resources
  class ComputeServices < Base
    friendly_attributes  :status, :binary, :host, :zone, :state, :disabled_reason, :forced_down

    self.service        = "compute"
    self.resource_name  = "service"
    self.resources_name = "os-services"

    class << self
      def enable(host, binary)
        params = {
          "host" => host,
          "binary" => binary,
        }
        put("enable", params)
      end

      def disable(host, binary, reason = nil)
        params = {
          "host" => host,
          "binary" => binary,
        }
        if reason
          params["disabled_reason"] = reason
          put("disable-log-reason", params)
        else
          put("disable", params)
        end
      end

      private
      def put(path, params)
        res = PUT(create_url([api_version, resources_path, path]), params) do |req|
          req.body = params.to_json
          req.headers['Content-Type'] = 'application/json'
        end
        return_resource(resource_from_json(res.body))
      end
    end

  end
end