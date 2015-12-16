require 'yao/plugins'
require 'faraday'
require 'faraday_middleware'
require 'yao/faraday_middlewares'

module Yao::Plugins
  class DefaultClientGenerator
    def call(f, token)
      f.request :accept, 'application/json'
      f.request :url_encoded

      if token
        f.request :os_token, token
      end

      f.request :get_only

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

    Yao::Plugins.register(self, type: :client_generator)

    Yao.config.param :client_generator, :default do |v|
      raise("Invalid client_generator name %s.\nNote: name must be a Symbol" % v.inspect) unless Registry.instance[:client_generator][v]
    end
  end
end
