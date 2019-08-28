class TestYaoResouce < Test::Unit::TestCase
  include AuthStub

  def setup
    initialize_test_client!
  end

  private

  # Yao::Resources::* のテストで Yao.default.pool の設定を都度都度 記述しなくていいよういするヘルパー
  # endpoint の URL がマチマチだとテストを記述するのが面倒なので example.com で統一している
  def initialize_test_client!
    auth_url = "http://example.com:12345"
    username = "yao"
    tenant   = "default"
    password = "password"

    stub_auth_request(auth_url, username, password, tenant)

    Yao.config.set :auth_url, auth_url
    Yao::Auth.new(tenant_name: tenant, username: username, password: password)

    client = Yao::Client.gen_client("https://example.com:12345")
    Yao.default_client.admin_pool["identity"] = client
    Yao.default_client.pool["network"]        = client
    Yao.default_client.pool["compute"]        = client
    Yao.default_client.pool["metering"]       = client
  end
end
