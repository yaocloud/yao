class TestAuthV3 < Test::Unit::TestCase
  include AuthV3Stub

  def setup
    @auth_url = "http://endpoint.example.com:12345/v3"
    username = "udzura"
    tenant   = "example"
    password = "XXXXXXXX"
    identity_api_version = "3"
    user_domain_name = "default"
    project_domain_name = "default"

    stub_auth_request(@auth_url, username, password, tenant, user_domain_name, project_domain_name)

    Yao.config.set :auth_url, @auth_url
    @token = Yao::Auth.new(tenant_name: tenant, username: username, password: password,
                           identity_api_version: identity_api_version,
                           user_domain_name: user_domain_name, project_domain_name: project_domain_name)
  end

  def teardown
    Yao.configure do
      endpoints            nil
      identity_api_version nil
    end
  end

  def test_auth_successful
    cli = Yao.default_client.pool["default"]
    assert { cli.url_prefix.to_s == "http://endpoint.example.com:12345/v3" }
  end

  def test_service_sclients_initialized
    %w(compute network image identity).each do |service|
      cli = Yao.default_client.pool[service]
      assert { !cli.nil? }
    end
  end

  def test_nova_tenant_logged_in
    tenant_id = "b598bf98671c47e1b955f8c9660e3c44"
    cli = Yao.default_client.compute
    assert { cli.url_prefix.to_s == "http://nova-endpoint.example.com:8774/v2/#{tenant_id}" }
  end

  def test_neutron_prefix_added
    cli = Yao.default_client.network
    assert { cli.url_prefix.to_s == "http://neutron-endpoint.example.com:9696/v2.0" }
  end

  def test_token_is_valid
    assert { @token.token == "aaaa166533fd49f3b11b1cdce2430000" }
    assert { @token.expire_at - @token.issued_at == 3600 }
    assert { @token.endpoints.size == 5 }
  end

  def test_hooked_by_configure_block
    auth = Yao::Auth
    stub(auth).new

    Yao.configure do
      auth_url             "http://endpoint.example.com:12345/v2.0"
      tenant_name          "example"
      username             "udzura"
      password             "XXXXXXXX"
      identity_api_version "3"
      user_domain_name     "default"
      project_domain_name  "default"
    end
    assert_received(auth) {|a| a.new }
  end

  def test_override_endpoint
    Yao.configure do
      auth_url             "http://endpoint.example.com:12345/v3"
      tenant_name          "example"
      username             "udzura"
      password             "XXXXXXXX"
      identity_api_version "3"
      user_domain_name     "default"
      project_domain_name  "default"
      endpoints ({ identity: { public: "http://override-endpoint.example.com:35357/v3.0" } })
    end
    assert { Yao.default_client.pool["identity"].url_prefix.to_s == "http://override-endpoint.example.com:35357/v3.0" }
  end

  def test_region
    Yao.configure do
      auth_url             "http://endpoint.example.com:12345/v3"
      tenant_name          "example"
      username             "udzura"
      password             "XXXXXXXX"
      identity_api_version "3"
      user_domain_name     "default"
      project_domain_name  "default"
      region_name          "RegionTest"
    end
    assert { Yao.default_client.pool["identity"].url_prefix.to_s == "https://global-endpoint.example.com/api/keystone/" }
  ensure
    Yao.configure do
      region_name "RegionOne"
    end
  end

end
