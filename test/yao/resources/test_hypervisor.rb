class TestHypervisor < Test::Unit::TestCase
  def test_hypervisor
    params = {
      "status" => "enabled"
    }

    host = Yao::Hypervisor.new(params)
    assert_equal(host.enabled?, true)
  end

  def setup
    Yao.default_client.pool["compute"] = Yao::Client.gen_client("https://example.com:12345")
  end

  def test_list_detail
    stub_request(:get, "https://example.com:12345/os-hypervisors/detail")
      .with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'})
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "hypervisors": [{
            "id": "dummy"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    h = Yao::Resources::Hypervisor.list_detail
    assert_equal(h.first.id, "dummy")
  end
end
