class TestToken < Test::Unit::TestCase
  include AuthStub

  def setup
    stub(Yao.config).debug { false }
    stub(Yao.config).debug_record_response { false }
  end

  def test_expired
    t = Yao::Token.new({})
    t.register({
        "id" => "aaaa166533fd49f3b11b1cdce2430000",
        "issued_at" => Time.now.iso8601,
        "expires" => (Time.now - 3600).utc.iso8601
      })

    assert { t.expired? }

    t.register({
        "id" => "aaaa166533fd49f3b11b1cdce2430000",
        "issued_at" => Time.now.iso8601,
        "expires" => (Time.now + 3600).utc.iso8601
      })
    assert { ! t.expired? }
  end

  AUTH_JSON = \
    "{\"auth\":{\"passwordCredentials\":{\"username\":\"udzura\",\"password\":\"XXXXXXXX\"},\"tenantName\":\"example\"}}"

  def gen_response_json
    <<-JSON
{
  "access": {
    "token": {
      "issued_at": "#{Time.now.iso8601}",
      "expires": "#{(Time.now + 3600).utc.iso8601}",
      "id": "aaaa166533fd49f3b11b1cdce2430000",
      "tenant": {
        "description": "Testing",
        "enabled": true,
        "id": "aaaa166533fd49f3b11b1cdce2430000",
        "name": "example"
      }
    },
    "serviceCatalog": []
  }
}
    JSON
  end

  def test_reflesh
    auth_url = "http://endpoint.example.com:12345"
    username = "udzura"
    tenant   = "example"
    password = "XXXXXXXX"

    auth_info = {
      auth: {
        passwordCredentials: {
          username: username, password: password
        },
        tenantName: tenant
      }
    }
    t = Yao::Token.new(auth_info)
    t.register({
        "id" => "old_token",
        "issued_at" => Time.now.iso8601,
        "expires" => (Time.now - 3600).utc.iso8601
      })
    assert { t.token == "old_token" }

    stub_auth_request(auth_url, username, password, tenant)

    Yao.config.auth_url auth_url
    t.reflesh(Yao.default_client.default)

    assert { t.token == "aaaa166533fd49f3b11b1cdce2430000" }
  end
end
