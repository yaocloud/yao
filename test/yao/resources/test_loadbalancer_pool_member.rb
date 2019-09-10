class TestLoadBalancerPoolMember < TestYaoResource
  def test_loadbalancer_pool_member
    params = {
      "monitor_port" => 8080,
      "name" => "web-server-1",
      "weight" => 20,
      "admin_state_up" => true,
      "created_at" => "2017-05-11T17:21:34",
      "provisioning_status" => "ACTIVE",
      "monitor_address" => nil,
      "updated_at" => "2017-05-11T17:21:37",
      "address" => "192.0.2.16",
      "protocol_port" => 80,
      "operating_status" => "NO_MONITOR"
    }

    member = Yao::Resources::LoadBalancerPoolMember.new(params)
    assert_equal(8080, member.monitor_port)
    assert_equal("web-server-1", member.name)
    assert_equal(20, member.weight)
    assert_equal(true, member.admin_state_up)
    assert_equal(Time.parse("2017-05-11T17:21:34"), member.created)
    assert_equal("ACTIVE", member.provisioning_status)
    assert_equal(nil, member.monitor_address)
    assert_equal(Time.parse("2017-05-11T17:21:37"), member.updated)
    assert_equal("192.0.2.16", member.address)
    assert_equal(80, member.protocol_port)
    assert_equal("NO_MONITOR", member.operating_status)
  end
end
