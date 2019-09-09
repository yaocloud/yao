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
    assert_equal(pool.lb_algorithm, "ROUND_ROBIN")
    assert_equal(pool.protocol, "HTTP")
    assert_equal(pool.description, "My round robin pool")
    assert_equal(pool.admin_state_up, true)
    assert_equal(pool.created, Time.parse("2017-04-13T18:14:44"))
    assert_equal(pool.provisioning_status, "ACTIVE")
    assert_equal(pool.updated, Time.parse("2017-04-13T23:08:12"))
    assert_equal(pool.session_persistence, {
        "cookie_name" => nil,
        "type" => "SOURCE_IP"
    })
    assert_equal(pool.operating_status, "ONLINE")
    assert_equal(pool.name, "round_robin_pool")
  end
end
