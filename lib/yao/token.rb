require 'yao/client'

module Yao
  class Token
    def self.issue(cli, auth_info)
      t = new(auth_info)
      t.refresh(cli)
      t
    end

    def initialize(auth_info, token_data=nil)
      @auth_info = auth_info

      @endpoints = {}
    end
    attr_accessor :auth_info, :token, :issued_at, :expire_at, :endpoints
    alias expires expire_at
    alias to_s token

    def register(token_data)
      @token = token_data["id"]
      @issued_at = Time.parse(token_data["issued_at"]).localtime
      @expire_at = Time.parse(token_data["expires"]).localtime
      Yao.current_tenant_id token_data["tenant"]["id"]
    end

    def expired?
      return true unless self.expire_at
      Time.now >= self.expire_at
    end

    def refresh(cli)
      @endpoints.clear

      res = cli.post("#{Yao.config.auth_url}/tokens") do |req|
        req.body = auth_info.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      body = res.body["access"]

      register(body["token"])
      register_endpoints(body["serviceCatalog"])
      self
    end

    def register_endpoints(_endpoints)
      return unless _endpoints

      _endpoints.each do |endpoint_data|
        type = endpoint_data["type"]
        endpoint = endpoint_data["endpoints"].first
        urls = {}
        urls[:public_url] = endpoint["publicURL"] if endpoint["publicURL"]
        urls[:admin_url]  = endpoint["adminURL"]  if endpoint["adminURL"]

        @endpoints[type] = urls
      end

      Yao.default_client.register_endpoints(@endpoints, token: self)
    end
  end

  def self.current_tenant_id(id=nil)
    if id
      @__tenant_id = id
    end
    @__tenant_id
  end
end
