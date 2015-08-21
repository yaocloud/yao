require 'oslo'
require 'oslo/config'
require 'faraday'
require 'faraday_middleware'
require 'oslo/faraday_middlewares'

module Oslo
  module Client
    class ClientSet
      def initialize
        @pool = {}
      end
      attr_reader :pool

      %w(default compute network image metering volume orchestration identity).each do |type|
        define_method(type) do
          self.pool[type]
        end
      end

      def register_endpoints(endpoints, token: nil)
        endpoints.each_pair do |type, endpoint|
          # XXX: neutron just have v2.0 API and endpoint may not have version prefix
          if type == "network" && URI.parse(endpoint).path == "/"
            endpoint = File.join(endpoint, "v2.0")
          end

          self.pool[type] = Oslo::Client.gen_client(endpoint, token: token)
        end
      end
    end

    class << self
      attr_accessor :default_client

      def gen_client(endpoint, token: nil)
        Faraday.new( endpoint ) do |f|
          f.request :url_encoded
          f.request :json

          if token
            f.request :os_token, token
          end

          f.response :json, :content_type => /\bjson$/
          f.response :logger

          f.adapter Faraday.default_adapter
        end
      end

      def reset_client(new_endpoint=nil)
        set = ClientSet.new
        set.register_endpoints("default" => (new_endpoint || Oslo.config.endpoint))
        self.default_client = set
      end
    end

    Oslo.config.param :auth_url, nil do |endpoint|
      if endpoint
        Oslo::Client.reset_client(endpoint)
        Oslo::Auth.try_new
      end
    end
  end

  def self.default_client
    Oslo::Client.default_client
  end
end
