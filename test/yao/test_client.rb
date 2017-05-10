class TestClient < Test::Unit::TestCase
  def setup
    stub(Yao.config).debug { false }
    stub(Yao.config).debug_record_response { false }
  end

  def test_gen_client
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    assert { cli.url_prefix.to_s == "http://cool-api.example.com:12345/v3.0" }

    handlers = [
      Faraday::Request::Accept,
      Faraday::Request::UrlEncoded,
      Faraday::Request::ReadOnly,
      Faraday::Response::OSErrorDetector,
      FaradayMiddleware::ParseJson,
      Faraday::Adapter::NetHttp
    ]
    assert { cli.builder.handlers == handlers }
  end

  def test_gen_with_token
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0", token: "deadbeaf")
    handlers = [
      Faraday::Request::Accept,
      Faraday::Request::UrlEncoded,
      Faraday::Request::OSToken,
      Faraday::Request::ReadOnly,
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
      Faraday::Request::Accept,
      Faraday::Request::UrlEncoded,
      Faraday::Request::ReadOnly,
      Faraday::Response::OSErrorDetector,
      FaradayMiddleware::ParseJson,
      Faraday::Response::Logger,
      Faraday::Response::OSDumper,
      Faraday::Adapter::NetHttp
    ]
    assert { cli.builder.handlers == handlers }
  end

  def test_timeout
    stub(Yao.config).timeout { 300 }
    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    assert { cli.options.timeout == 300 }
  end

  def test_cert_key
    stub(Yao.config).client_cert { File.expand_path("../../fixtures/dummy.pem", __FILE__) }
    stub(Yao.config).client_key  { File.expand_path("../../fixtures/dummy.key", __FILE__) }
    stub(OpenSSL::X509::Certificate).new { "DummyCert" }
    stub(OpenSSL::PKey).read { "DummyKey" }

    cli = Yao::Client.gen_client("http://cool-api.example.com:12345/v3.0")
    ssl = cli.ssl
    assert { ssl[:client_cert] == "DummyCert" }
    assert { ssl[:client_key] == "DummyKey" }
  end
end
