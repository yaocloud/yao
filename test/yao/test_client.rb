class TestClient < Test::Unit::TestCase
  def setup
    stub(Yao.config).debug { false }
    stub(Yao.config).debug_record_response { false }
  end

  def test_gen_client
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    assert { cli.url_prefix.to_s == "http://cool-api.example.com:12345/v3.0" }

    handlers = [
      Faraday::Request::UrlEncoded,
      FaradayMiddleware::EncodeJson,
      Faraday::Response::OSErrorDetector,
      FaradayMiddleware::ParseJson,
      Faraday::Adapter::NetHttp
    ]
    assert { cli.builder.handlers == handlers }
  end

  def test_gen_with_token
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0", token: "deadbeaf")
    handlers = [
      Faraday::Request::UrlEncoded,
      FaradayMiddleware::EncodeJson,
      Faraday::Request::OSToken,
      Faraday::Response::OSErrorDetector,
      FaradayMiddleware::ParseJson,
      Faraday::Adapter::NetHttp
    ]
    assert { cli.builder.handlers == handlers }
  end

  def test_debug_mode
    stub(Yao.config).debug { true }

    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    handlers = [
      Faraday::Request::UrlEncoded,
      FaradayMiddleware::EncodeJson,
      Faraday::Response::OSErrorDetector,
      FaradayMiddleware::ParseJson,
      Faraday::Response::Logger,
      Faraday::Response::OSDumper,
      Faraday::Adapter::NetHttp
    ]
    assert { cli.builder.handlers == handlers }
  end
end
