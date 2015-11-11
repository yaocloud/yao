class TestClientPlugin < Test::Unit::TestCase
  def setup
    stub(Yao.config).debug { false }
    stub(Yao.config).debug_record_response { false }
  end

  def teardown
    Yao.config.set :client_generator, :default
  end

  def test_raise_invalid_name
    e = nil
    begin
      Yao.config.set :client_generator, :nonexist
    rescue => e
    end

    assert { e.is_a? StandardError }
    assert { e.message == "Invalid client_generator name :nonexist.\nNote: name must be a Symbol" }
  end

  class ::Yao::Plugins::TestCustomClientGenerator
    def call(f, t)
      f.response :xml, :content_type => /\/xml$/
    end
    ::Yao::Plugins.register self, type: :client_generator, name: :test_custom
  end

  def test_gen_client_with_custom
    Yao.config.set :client_generator, :test_custom

    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    handlers = [
      FaradayMiddleware::ParseXml,
    ]
    assert { cli.builder.handlers == handlers }
  end
end
