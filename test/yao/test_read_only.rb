class TestOnly < Test::Unit::TestCase
  include AuthStub

  def setup
    auth_url = "http://endpoint.example.com:12345"
    username = "udzura"
    tenant   = "example"
    password = "XXXXXXXX"

    stub_auth_request(auth_url, username, password, tenant)

    Yao.configure do
      auth_url    auth_url
      username    username
      tenant_name tenant
      password    password
    end

    @username = username
    @get_stub  = stub_request(:get,  "#{auth_url}/v2.0/users?name=#{username}")
    @post_stub = stub_request(:post, "#{auth_url}/v2.0/users")
  end

  def test_read_only
    Yao.read_only do
      Yao::User.get_by_name(@username)
      Yao::User.create(name: "foo", email: "bar", password: "baz")
    end

    assert_requested @get_stub
    assert_not_requested @post_stub
  end

  def test_read_only!
    assert_raise Yao::GetOnlyViolationError do
      Yao.read_only! do
        Yao::User.get_by_name(@username)
        Yao::User.create(name: "foo", email: "bar", password: "baz")
      end
    end

    assert_requested @get_stub
    assert_not_requested @post_stub
  end
end
