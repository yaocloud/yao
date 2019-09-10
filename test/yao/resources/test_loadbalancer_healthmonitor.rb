class TestLoadBalancerHealthMonitor < TestYaoResource
  def test_loadbalancer_healtchmonitor
    params = {
      "name" => "super-pool-health-monitor",
      "admin_state_up" => true,
      "created_at" => "2017-05-11T23:53:47",
      "provisioning_status" => "ACTIVE",
      "updated_at" => "2017-05-11T23:53:47",
      "delay" => 10,
      "expected_codes" => "200",
      "max_retries" => 1,
      "http_method" => "GET",
      "timeout" => 5,
      "max_retries_down" => 3,
      "url_path" => "/",
      "type" => "HTTP",
      "operating_status" => "ONLINE"
    }

    healthmonitor = Yao::Resources::LoadBalancerHealthMonitor.new(params)
    assert_equal("super-pool-health-monitor", healthmonitor.name)
    assert_equal(true, healthmonitor.admin_state_up)
    assert_equal(Time.parse("2017-05-11T23:53:47"), healthmonitor.created)
    assert_equal("ACTIVE", healthmonitor.provisioning_status)
    assert_equal(Time.parse("2017-05-11T23:53:47"), healthmonitor.updated)
    assert_equal(10, healthmonitor.delay)
    assert_equal("200", healthmonitor.expected_codes)
    assert_equal(1, healthmonitor.max_retries)
    assert_equal("GET", healthmonitor.http_method)
    assert_equal(5, healthmonitor.timeout)
    assert_equal(3, healthmonitor.max_retries_down)
    assert_equal("/", healthmonitor.url_path)
    assert_equal("HTTP", healthmonitor.type)
    assert_equal("ONLINE", healthmonitor.operating_status)
  end
end
