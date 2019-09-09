class TestOnly < Test::Unit::TestCase
  include AuthStub

  def setup
    auth_url = "http://endpoint.example.com:12345/v2.0"
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
    @get_stub  = stub_request(:get,  "#{auth_url}/users/#{username}")
    @post_stub = stub_request(:post, "#{auth_url}/users")
  end

  def test_read_only
    Yao.read_only do
      Yao::User.get(@username)
      Yao::User.create(name: "foo", email: "bar", password: "baz")
    end

    assert_requested @get_stub
    assert_not_requested @post_stub
  end

  def test_read_only!
    assert_raise Yao::ReadOnlyViolationError do
      Yao.read_only! do
        Yao::User.get(@username)
        Yao::User.create(name: "foo", email: "bar", password: "baz")
      end
    end

    assert_requested @get_stub
    assert_not_requested @post_stub
  end

  def test_read_only_flags_life_cycle
    assert_false Yao.config.noop_on_write
    assert_false Yao.config.raise_on_write

    assert_raise RuntimeError do
      Yao.read_only do
        assert_true Yao.config.noop_on_write
        raise
      end
    end

    assert_false Yao.config.noop_on_write
    assert_false Yao.config.raise_on_write

    assert_raise RuntimeError do
      Yao.read_only! do
        assert_true Yao.config.raise_on_write
        raise
      end
    end

    assert_false Yao.config.noop_on_write
    assert_false Yao.config.raise_on_write
  end

  def test_reentrant_condition
    Yao.read_only do
      assert_true Yao.config.noop_on_write

      Yao.read_only do
        assert_true Yao.config.noop_on_write
      end

      assert_true Yao.config.noop_on_write
    end

    Yao.read_only! do
      assert_true Yao.config.raise_on_write

      Yao.read_only! do
        assert_true Yao.config.raise_on_write
      end

      assert_true Yao.config.raise_on_write
    end

    Yao.read_only! do
      assert_true Yao.config.raise_on_write

      Yao.read_only do
        assert_true  Yao.config.noop_on_write
        assert_false Yao.config.raise_on_write
      end

      assert_true Yao.config.raise_on_write
    end

    Yao.read_only do
      assert_true Yao.config.noop_on_write

      Yao.read_only! do
        assert_true  Yao.config.raise_on_write
        assert_false Yao.config.noop_on_write
      end

      assert_true Yao.config.noop_on_write
    end
  end
end
