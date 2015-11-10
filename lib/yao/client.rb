require 'yao'
require 'yao/config'
require 'faraday'
require 'faraday_middleware'
require 'yao/faraday_middlewares'

module Yao
  module Client
    class ClientSet
      def initialize
        @pool       = {}
        @admin_pool = {}
      end
      attr_reader :pool, :admin_pool

      %w(default compute network image metering volume orchestration identity).each do |type|
        define_method(type) do
          self.pool[type]
        end

        define_method("#{type}_admin") do
          self.admin_pool[type]
        end
      end

      def register_endpoints(endpoints, token: nil)
        endpoints.each_pair do |type, urls|
          # XXX: neutron just have v2.0 API and endpoint may not have version prefix
          if type == "network"
            urls = urls.map {|public_or_admin, url|
              url = URI.parse(url).path == "/" ? File.join(url, "v2.0") : url
              [public_or_admin, url]
            }.to_h
          end

          self.pool[type]       = Yao::Client.gen_client(urls[:public_url], token: token)
          self.admin_pool[type] = Yao::Client.gen_client(urls[:admin_url],  token: token)
        end
      end
    end

    class << self
      attr_accessor :default_client

      def client_generator_hook
        lambda do |f, token|
          f.request :accept, 'application/json'
          f.request :url_encoded

          if token
            f.request :os_token, token
          end

          f.response :os_error_detector
          f.response :json, :content_type => /\bjson$/

          if Yao.config.debug
            f.response :logger
            f.response :os_dumper
          end

          if Yao.config.debug_record_response
            f.response :os_response_recorder
          end

          f.adapter Faraday.default_adapter
        end
      end

      def gen_client(endpoint, token: nil)
        Faraday.new( endpoint ) do |f|
          client_generator_hook.call(f, token)
        end
      end

      def reset_client(new_endpoint=nil)
        set = ClientSet.new
        set.register_endpoints("default" => {public_url: new_endpoint || Yao.config.endpoint})
        self.default_client = set
      end
    end

    Yao.config.param :auth_url, nil do |endpoint|
      if endpoint
        Yao::Client.reset_client(endpoint)
      end
    end
  end

  def self.default_client
    Yao::Client.default_client
  end

  Yao.config.param :debug, false
  Yao.config.param :debug_record_response, false
end
