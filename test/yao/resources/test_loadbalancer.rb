require "date"

class TestRole < Test::Unit::TestCase
  def test_loadbalancer
    params = {
      "provider" => "octavia",
      "description" => "greate loadbalancer",
      "admin_state_up" => true,
      "provisioning_status" => "ACTIVE",
      "pools" => [{"id" => "pool"}],
      "listeners" => [{"id" => "listener"}],
      "vip_address" => "198.51.100.1",
      "operationg_status" => "ONLINE",
      "name" => "greate loadbalancer",
      "created_at" => "2017-02-28T00:41:44",
      "updated_at" => "2017-02-28T00:43:30",
    }

    lb = Yao::LoadBalancer.new(params)
    assert_equal(lb.provider, "octavia")
    assert_equal(lb.description, "greate loadbalancer")
    assert_equal(lb.admin_state_up, true)
    assert_equal(lb.provisioning_status, "ACTIVE")
    assert_equal(lb.pools, [{"id" => "pool"}])
    assert_equal(lb.listeners, [{"id" => "listener"}])
    assert_equal(lb.vip_address, "198.51.100.1")
    assert_equal(lb.operationg_status, "ONLINE")
    assert_equal(lb.name, "greate loadbalancer")
    assert_equal(lb.created_at, Date.parse("2017-02-28T00:41:44"))
    assert_equal(lb.updated_at, Date.parse("2017-02-28T00:43:30"))
  end
end
