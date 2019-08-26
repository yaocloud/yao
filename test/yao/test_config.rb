class TestConfig < Test::Unit::TestCase
  def test_define_param
    assert { !Yao.config.respond_to?(:foobar) }

    Yao.config.param :foobar, nil
    assert { Yao.config.respond_to?(:foobar) }
  end

  def test_raise_undefined_key
    e = nil
    begin
      Yao.config.set :some_imaginary_key, 123
    rescue => e
    end
    assert { e.message == "Undefined config key some_imaginary_key" }
  end

  def test_define_hook
    hooked_value = nil

    Yao.config.param :do_hook, "sample" do |v|
      hooked_value = v
    end
    assert("param definition should not hook callbacks") do
      hooked_value.nil?
    end

    Yao.config.set :do_hook, "true value"
    assert { hooked_value = "true value" }

    Yao.config.do_hook("next value")
    assert { Yao.config.do_hook == "next value" }
    assert { hooked_value == "next value" }
  end

  def test_delayed_hook
    hooked_value = nil
    Yao.config.param :def_hook1, "test" do |v|
      if Yao.config.def_hook2
        hooked_value = v
      end
    end
    Yao.config.param :def_hook2, false

    Yao.configure do
      def_hook1 "test 2"
      def_hook2 true
    end

    assert { hooked_value == "test 2" }
  end

  sub_test_case 'setting Yao.configure' do

    def test_auth_is_hooked
      auth = Yao::Auth
      count = Yao::Config::HOOK_RENEW_CLIENT_KEYS.size
      mock(auth).try_new.times(count)
      Yao::Config::HOOK_RENEW_CLIENT_KEYS.each do |key|
        # configurations have side effects !!!!
        Yao.configure do
          set key, "http://dummy"
        end
      end

      assert_received(auth) {|a| a.try_new.times(count) }
    end

    # reset configurations of Yao.configure
    def teardown
      Yao::Config::HOOK_RENEW_CLIENT_KEYS.each do |key|
        Yao.configure do
          set key, nil
        end
      end
    end
  end
end
