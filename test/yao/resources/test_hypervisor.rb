class TestHypervisor < Test::Unit::TestCase

  include AuthStub

  def setup
    initialize_test_client!
  end

  def test_hypervisor
    params = {
      "status" => "enabled"
    }

    host = Yao::Hypervisor.new(params)
    assert_equal(host.enabled?, true)
  end

  def test_list_detail
    stub_request(:get, "https://example.com:12345/os-hypervisors/detail")
      .with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Faraday v#{Faraday::VERSION}"})
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

  def test_statistics
    stub_request(:get, "https://example.com:12345/os-hypervisors/statistics")
      .with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Faraday v#{Faraday::VERSION}"})
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "hypervisor_statistics": {
            "count": 1,
            "current_workload": 0,
            "disk_available_least": 0,
            "free_disk_gb": 1028,
            "free_ram_mb": 7680,
            "local_gb": 1028,
            "local_gb_used": 0,
            "memory_mb": 8192,
            "memory_mb_used": 512,
            "running_vms": 0,
            "vcpus": 2,
            "vcpus_used": 0
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    s = Yao::Resources::Hypervisor.statistics
    assert_equal(s.count, 1)
  end

  def test_uptime
    stub_request(:get, "https://example.com:12345/os-hypervisors/1/uptime")
      .with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Faraday v#{Faraday::VERSION}"})
      .to_return(
        status: 200,
        body: <<-JSON,
        {
            "hypervisor": {
                "hypervisor_hostname": "fake-mini",
                "id": 1,
                "state": "up",
                "status": "enabled",
                "uptime": " 08:32:11 up 93 days, 18:25, 12 users,  load average: 0.20, 0.12, 0.14"
            }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    u = Yao::Resources::Hypervisor.uptime(1)
    assert_equal(u.uptime, " 08:32:11 up 93 days, 18:25, 12 users,  load average: 0.20, 0.12, 0.14")
  end
end
