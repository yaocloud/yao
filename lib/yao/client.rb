require 'yao/config'
require 'faraday'
require 'openssl'
require 'yao/plugins/default_client_generator'

module Yao
  Yao.config.param :endpoints, nil

  module Client
    class ClientSet
      def initialize
        @pool       = {}
        @admin_pool = {}
      end

      # #pool and #admin_pool returns Hash like below structure
      #
      # {
      #   "identity" => #<Faraday::Connection:...>,
      #   "image"    => #<Faraday::Connection:...>,
      # }
      #
      # @return [Hash { String => Faraday::Connection }]
      attr_reader :pool, :admin_pool

      %w(default compute network image metering volume orchestration identity).each do |type|

        # @return [Faraday::Connection]
        define_method(type) do
          self.pool[type]
        end

        # @return [Faraday::Connection]
        define_method("#{type}_admin") do
          self.admin_pool[type]
        end
      end

      # endpoints is a Hash like below structure
      #
      # {
      #   "identity" => {
      #       public_url:   "https://example.com/mitaka/keystone/v3",
      #       internal_url: "https://example.com/mitaka/keystone/v3",
      #       admin_url:    "https://example.com/mitaka/admin/keystone/v3"
      #   },
      #   "image" => {
      #     ...
      #   },
      # }
      #
      # @param endpoints [Hash{ String => Hash }]
      def register_endpoints(endpoints, token: nil)

        # type is String (e.g. network, identity, ... )
        # urls is Hash{ Symbol => String }
        endpoints.each_pair do |type, urls|

          # XXX: neutron just have v2.0 API and endpoint may not have version prefix
          if type == "network"
            urls = urls.map {|public_or_admin, url|
              url = File.join(url, "v2.0")
              [public_or_admin, url]
            }.to_h
          end

          # User can override the public_url and admin_url of endpoints by setting Yao.configure
          # For example.
          #
          #   Yao.configure do
          #     endpoints identity: { public: "http://override-endpoint.example.com:35357/v3.0" }
          #   end
          #
          force_public_url = Yao.config.endpoints[type.to_sym][:public] rescue nil
          force_admin_url  = Yao.config.endpoints[type.to_sym][:admin]  rescue nil

          if force_public_url || urls[:public_url]
            self.pool[type] = Yao::Client.gen_client(force_public_url || urls[:public_url], token: token)
          end

          if force_admin_url || urls[:admin_url]
            self.admin_pool[type] = Yao::Client.gen_client(force_admin_url || urls[:admin_url],  token: token)
          end
        end
      end
    end

    class << self

      # @return [Yao::Client::ClientSet]
      attr_accessor :default_client

      # @return [Yao::Plugins::DefaultClientGenerator]
      def client_generator
        Plugins::Registry.instance[:client_generator][Yao.config.client_generator].new
      end

      # @param endpoint [String]
      # @param token    [String]
      # @return [Faraday::Connection]
      def gen_client(endpoint, token: nil)
        Faraday.new( endpoint, client_options ) do |f|
          client_generator.call(f, token)
        end
      end

      # @param [String]
      def reset_client(new_endpoint=nil)
        set = ClientSet.new
        endpoint = {
          "default" => {public_url: new_endpoint || Yao.config.endpoint}
        }
        set.register_endpoints(endpoint)
        self.default_client = set
      end

      # generate Hash options for Faraday.new
      # @return [Hash]
      def client_options
        opt = {}

        if Yao.config.timeout
          opt.merge!({ request: { timeout: Yao.config.timeout }})
        end

        # Client Certificate Authentication
        if Yao.config.client_cert && Yao.config.client_key
          cert = OpenSSL::X509::Certificate.new(File.read(Yao.config.client_cert))
          key  = OpenSSL::PKey.read(File.read(Yao.config.client_key))
          opt.merge!(ssl: {
            client_cert: cert,
            client_key:  key,
          })
        end
        opt
      end
    end

    Yao.config.param :auth_url, nil do |endpoint|
      if endpoint
        Yao::Client.reset_client(endpoint)
      end
    end
  end

  # @return [Yao::Client::ClientSet]
  def self.default_client
    Yao::Client.default_client
  end

  Yao.config.param :noop_on_write, false
  Yao.config.param :raise_on_write, false

  Yao.config.param :debug, false
  Yao.config.param :debug_record_response, false
end
