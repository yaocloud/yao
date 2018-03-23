require 'yao/client'

module Yao
  class TokenV3
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

    def register(response)
      @token = response.headers["X-Subject-Token"]

      token_data = response.body["token"]
      @issued_at = Time.parse(token_data["issued_at"]).localtime
      @expire_at = Time.parse(token_data["expires_at"]).localtime
      Yao.current_tenant_id token_data["project"]["id"]
    end

    def expired?
      return true unless self.expire_at
      Time.now >= self.expire_at
    end

    def refresh(cli)
      @endpoints.clear

      res = cli.post("#{Yao.config.auth_url}/auth/tokens") do |req|
        req.body = auth_info.to_json
        req.headers['Content-Type'] = 'application/json'
      end

      register(res)
      register_endpoints(res.body["token"]["catalog"])
      self
    end

    def register_endpoints(_endpoints)
      return unless _endpoints

      _endpoints.each do |endpoint_data|
        type = endpoint_data["type"]
        region_name = Yao.config.region_name ? Yao.config.region_name : 'RegionOne'
        endpoints = endpoint_data["endpoints"].select { |ep| ep.has_value?(region_name) }
        urls = {}
        endpoints.each do |ep|
          name = "#{ep["interface"]}_url".to_sym
          urls[name] = ep["url"]
        end
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
