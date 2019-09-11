class TestLoadBalancer < TestYaoResource
  def test_loadbalancer
    params = {
      "provider" => "octavia",
      "description" => "greate loadbalancer",
      "admin_state_up" => true,
      "provisioning_status" => "ACTIVE",
      "vip_address" => "198.51.100.1",
      "operationg_status" => "ONLINE",
      "name" => "greate loadbalancer",
      "created_at" => "2017-02-28T00:41:44",
      "updated_at" => "2017-02-28T00:43:30",
    }

    lb = Yao::Resources::LoadBalancer.new(params)
    assert_equal("octavia", lb.provider)
    assert_equal("greate loadbalancer", lb.description)
    assert_equal(true, lb.admin_state_up)
    assert_equal("ACTIVE", lb.provisioning_status)
    assert_equal("198.51.100.1", lb.vip_address)
    assert_equal("ONLINE", lb.operationg_status)
    assert_equal("greate loadbalancer", lb.name)
    assert_equal(Time.parse("2017-02-28T00:41:44"), lb.created)
    assert_equal(Time.parse("2017-02-28T00:43:30"), lb.updated)
  end
end
