require 'oslo'
require 'oslo/config'
require 'faraday'
require 'faraday_middleware'

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

      def register_endpoints(endpoints)
        endpoints.each_pair do |type, endpoint|
          self.pool[type] = Oslo::Client.gen_client(endpoint)
        end
      end
    end

    class << self
      attr_accessor :default_client

      def gen_client(endpoint)
        Faraday.new( endpoint ) do |f|
          f.request :url_encoded
          f.request :json
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

    Oslo.config.param :endpoint, "http://localhost" do |endpoint|
      Oslo::Client.reset_client(endpoint)
    end

    self.reset_client
  end

  def self.default_client
    Oslo::Client.default_client
  end
end
