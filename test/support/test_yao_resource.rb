class TestYaoResource < Test::Unit::TestCase
  include AuthStub

  def setup
    initialize_test_client!
  end

  def teardown
    reset_test_client!
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
    Yao.default_client.pool["volumev3"]       = client
  end

  # 他のテストで副作用を出さないように Yao::Client.default_client, Yao::Conig を nil でリセットしておきます
  def reset_test_client!
    Yao::Client.default_client = nil

    Yao::Config::HOOK_RENEW_CLIENT_KEYS.each do |key|
      Yao.configure do
        set key, nil
      end
    end

    # https://github.com/bblimke/webmock/wiki/Clear-stubs-and-request-history
    # 他のテストに作用しないように stub_request を reset する
    WebMock.reset!
  end
end
