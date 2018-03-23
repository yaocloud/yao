class TestTokenV3 < Test::Unit::TestCase
  include AuthV3Stub

  class TestResponse
    attr :headers, :body

    def initialize
      @headers = Hash.new
      @body    = Hash.new
    end
  end

  def setup
    stub(Yao.config).debug { false }
    stub(Yao.config).debug_record_response { false }
  end

  def test_expired
    t = Yao::TokenV3.new({})
    r = TestResponse.new
    r.headers["X-Subject-Token"] = "aaaa166533fd49f3b11b1cdce2430000"
    r.body["token"] = {
      "issued_at"  => Time.now.iso8601,
      "expires_at" => (Time.now - 3600).utc.iso8601,
      "project"    => {
        "id" => "aaaa166533fd49f3b11b1cdce2430000"
      }
    }
    t.register(r)

    assert { t.expired? }

    r.body["token"] = {
      "issued_at"  => Time.now.iso8601,
      "expires_at" => (Time.now + 3600).utc.iso8601,
      "project"    => {
        "id" => "aaaa166533fd49f3b11b1cdce2430000"
      }
    }
    t.register(r)
    assert { ! t.expired? }
  end

  def test_refresh
    auth_url             = "http://endpoint.example.com:12345/v3"
    username             = "udzura"
    tenant               = "example"
    password             = "XXXXXXXX"
    identity_api_version = 3
    user_domain_name     = "default"
    project_domain_name  = "default"

    auth_info = {
      auth: {
        identity: {
          methods: ["password"],
          password: {
            user: {
              name: username, password: password,
              domain: { name: user_domain_name },
            }
          }
        },
        scope: {
          project: {
            name: tenant,
            domain: { name: project_domain_name },
          }
        }
      }
    }
    t = Yao::TokenV3.new(auth_info)
    r = TestResponse.new
    r.headers["X-Subject-Token"] = "old_token"
    r.body["token"] = {
      "issued_at"  => Time.now.iso8601,
      "expires_at" => (Time.now - 3600).utc.iso8601,
      "project"    => {
        "id" => "aaaa166533fd49f3b11b1cdce2430000"
      }
    }
    t.register(r)
    assert { t.token == "old_token" }

    stub_auth_request(auth_url, username, password, tenant, user_domain_name, project_domain_name)

    Yao.config.auth_url auth_url
    t.refresh(Yao.default_client.default)

    assert { t.token == "aaaa166533fd49f3b11b1cdce2430000" }
  end

  def test_current_tenant_id
    t = Yao::TokenV3.new({})
    r = TestResponse.new
    r.headers["X-Subject-Token"] = "aaaa166533fd49f3b11b1cdce2430000"
    r.body["token"] = {
      "issued_at"  => Time.now.iso8601,
      "expires_at" => (Time.now - 3600).utc.iso8601,
      "project"    => {
        "id" => "aaaa166533fd49f3b11b1cdce2430000"
      }
    }
    t.register(r)

    assert { Yao.current_tenant_id == "aaaa166533fd49f3b11b1cdce2430000" }
  end
end
