require 'oslo'
require 'oslo/config'
require 'faraday'
require 'faraday_middleware'

module Oslo::Client
  class << self
    attr_accessor :conn

    def init_client(endpoint)
      Faraday.new( endpoint ) do |f|
        f.request :url_encoded
        f.request :json
        f.response :json, :content_type => /\bjson$/
        f.response :logger

        f.adapter Faraday.default_adapter
      end
    end

    def reset_client(new_endpoint=nil)
      self.conn = init_client(new_endpoint || Oslo.config.endpoint)
    end
  end

  Oslo.config.param :endpoint, "http://localhost" do |endpoint|
    Oslo::Client.reset_client(endpoint)
  end

  self.reset_client
end
