require 'yao/client'

module Yao
  class Token
    def initialize(token_data)
      @token = token_data["id"]
      @issued_at = Time.parse token_data["issued_at"]
      @expire_at = Time.parse token_data["expires"]

      @endpoints = {}
    end
    attr_accessor :token, :issued_at, :expire_at, :endpoints
    alias expires expire_at

    def register_endpoints(_endpoints)
      return unless _endpoints

      _endpoints.each do |endpoint_data|
        key = endpoint_data["type"]
        value = if d = endpoint_data["endpoints"].first
                  d["publicURL"]
                else
                  nil
                end
        if value
          @endpoints[key] = value
        end
      end
      Yao.default_client.register_endpoints(@endpoints, token: @token)
    end
  end
end
