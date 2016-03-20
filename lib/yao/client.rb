require 'yao'
require 'yao/config'
require 'faraday'
require 'yao/plugins/default_client_generator'

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

          self.pool[type]       = Yao::Client.gen_client(urls[:public_url], token: token) if urls[:public_url]
          self.admin_pool[type] = Yao::Client.gen_client(urls[:admin_url],  token: token) if urls[:admin_url]
        end
      end
    end

    class << self
      attr_accessor :default_client

      def client_generator
        Plugins::Registry.instance[:client_generator][Yao.config.client_generator].new
      end

      def gen_client(endpoint, token: nil)
        Faraday.new( endpoint, client_options ) do |f|
          client_generator.call(f, token)
        end
      end

      def reset_client(new_endpoint=nil)
        set = ClientSet.new
        set.register_endpoints("default" => {public_url: new_endpoint || Yao.config.endpoint})
        self.default_client = set
      end

      def client_options
        opt = {}
        opt.merge!({ request: { timeout: Yao.config.timeout }}) if Yao.config.timeout
        opt
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

  Yao.config.param :noop_on_write, false
  Yao.config.param :raise_on_write, false

  Yao.config.param :debug, false
  Yao.config.param :debug_record_response, false
end
