class TestLoadBalancerPoolMember < TestYaoResouce
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
    assert_equal(member.monitor_port, 8080)
    assert_equal(member.name, "web-server-1")
    assert_equal(member.weight, 20)
    assert_equal(member.admin_state_up, true)
    assert_equal(member.created, Time.parse("2017-05-11T17:21:34"))
    assert_equal(member.provisioning_status, "ACTIVE")
    assert_equal(member.monitor_address, nil)
    assert_equal(member.updated, Time.parse("2017-05-11T17:21:37"))
    assert_equal(member.address, "192.0.2.16")
    assert_equal(member.protocol_port, 80)
    assert_equal(member.operating_status, "NO_MONITOR")
  end
end
