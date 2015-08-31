class TestClient < Test::Unit::TestCase
  def setup
    Yao.config.debug false
  end

  def test_gen_client
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    assert { cli.url_prefix.to_s == "http://cool-api.example.com:12345/v3.0" }
    assert do
      cli.builder.handlers == [
        Faraday::Request::UrlEncoded,
        FaradayMiddleware::EncodeJson,
        FaradayMiddleware::ParseJson,
        Faraday::Adapter::NetHttp
      ]
    end
  end

  def test_gen_with_token
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0", token: "deadbeaf")
    assert do
      cli.builder.handlers == [
        Faraday::Request::UrlEncoded,
        FaradayMiddleware::EncodeJson,
        Faraday::Request::OSToken,
        FaradayMiddleware::ParseJson,
        Faraday::Adapter::NetHttp
      ]
    end
  end

  def test_debug_mode
    Yao.config.debug true

    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    assert do
      cli.builder.handlers == [
        Faraday::Request::UrlEncoded,
        FaradayMiddleware::EncodeJson,
        FaradayMiddleware::ParseJson,
        Faraday::Response::Logger,
        Faraday::Request::OSDumper,
        Faraday::Adapter::NetHttp
      ]
    end
  end
end
