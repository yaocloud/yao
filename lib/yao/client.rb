require 'yao'
require 'yao/config'
require 'faraday'
require 'faraday_middleware'
require 'yao/faraday_middlewares'

module Yao
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

          self.pool[type] = Yao::Client.gen_client(endpoint, token: token)
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
          # FIXME: Yao global option
          if ENV['DEBUG']
            f.response :logger
            f.response :os_dumper
          end

          if ENV['RECORD_RESPONSE']
            f.response :os_response_recorder
          end

          f.adapter Faraday.default_adapter
        end
      end

      def reset_client(new_endpoint=nil)
        set = ClientSet.new
        set.register_endpoints("default" => (new_endpoint || Yao.config.endpoint))
        self.default_client = set
      end
    end

    Yao.config.param :auth_url, nil do |endpoint|
      if endpoint
        Yao::Client.reset_client(endpoint)
        Yao::Auth.try_new
      end
    end
  end

  def self.default_client
    Yao::Client.default_client
  end
end
