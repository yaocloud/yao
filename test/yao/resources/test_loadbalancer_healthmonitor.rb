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
    assert_equal(healthmonitor.name, "super-pool-health-monitor")
    assert_equal(healthmonitor.admin_state_up, true)
    assert_equal(healthmonitor.created, Time.parse("2017-05-11T23:53:47"))
    assert_equal(healthmonitor.provisioning_status, "ACTIVE")
    assert_equal(healthmonitor.updated, Time.parse("2017-05-11T23:53:47"))
    assert_equal(healthmonitor.delay, 10)
    assert_equal(healthmonitor.expected_codes, "200")
    assert_equal(healthmonitor.max_retries, 1)
    assert_equal(healthmonitor.http_method, "GET")
    assert_equal(healthmonitor.timeout, 5)
    assert_equal(healthmonitor.max_retries_down, 3)
    assert_equal(healthmonitor.url_path, "/")
    assert_equal(healthmonitor.type, "HTTP")
    assert_equal(healthmonitor.operating_status, "ONLINE")
  end
end
