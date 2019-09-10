class TestLoadBalancerPool < TestYaoResource
  def test_loadbalancer_pool
    params = {
      "lb_algorithm" => "ROUND_ROBIN",
      "protocol" => "HTTP",
      "description" => "My round robin pool",
      "admin_state_up" => true,
      "created_at" => "2017-04-13T18:14:44",
      "provisioning_status" => "ACTIVE",
      "updated_at" => "2017-04-13T23:08:12",
      "session_persistence" => {
        "cookie_name" => nil,
        "type" => "SOURCE_IP"
      },
      "operating_status" => "ONLINE",
      "name" => "round_robin_pool"
    }

    pool = Yao::Resources::LoadBalancerPool.new(params)
    assert_equal("ROUND_ROBIN", pool.lb_algorithm)
    assert_equal("HTTP", pool.protocol)
    assert_equal("My round robin pool", pool.description)
    assert_equal(true, pool.admin_state_up)
    assert_equal(Time.parse("2017-04-13T18:14:44"), pool.created)
    assert_equal("ACTIVE", pool.provisioning_status)
    assert_equal(Time.parse("2017-04-13T23:08:12"), pool.updated)
    assert_equal(pool.session_persistence, {
        "cookie_name" => nil,
        "type" => "SOURCE_IP"
    })
    assert_equal("ONLINE", pool.operating_status)
    assert_equal("round_robin_pool", pool.name)
  end
end
