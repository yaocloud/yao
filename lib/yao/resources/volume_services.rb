module Yao::Resources
  class VolumeServices < Base

    friendly_attributes :binary, :disabled_reason, :host, :state, :status,
                        :frozen, :zone, :cluster, :replication_status,
                        :active_backend_id, :backed_state
    map_attributes_to_time :updated_at

    self.service        = "volumev3"
    self.resource_name  = "os-service"
    self.resources_name = "os-services"

    # return true if ComputeServices is enabled
    # @return [Bool]
    def enabled?
      status == 'enabled'
    end

    # return true if ComputeServices is disabled
    # @return [Bool]
    def disabled?
      status == 'disabled'
    end

    def enable
      self.class.enable(host, binary)
    end

    def disable(reason = nil)
      self.class.disable(host, binary, reason)
    end

    class << self
      # @param host [String]
      # @param binary [String]
      # @return [Hash]
      def enable(host, binary)
        params = {
          "host" => host,
          "binary" => binary,
        }
        put("enable", params)
      end

      # @param host [String]
      # @param binary [String]
      # @param resason [String]
      # @return [Hash]
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

      # @param path [String]
      # @param  params [Hash]
      # @return [Hash]
      def put(path, params)
        res = PUT(create_url(path), params) do |req|
          req.body = params.to_json
          req.headers['Content-Type'] = 'application/json'
        end
        res.body
      end
    end
  end
end
