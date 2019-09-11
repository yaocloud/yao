class TestSecurityGroup < TestYaoResource
  def test_rule_attributes
    params = {
      "id" => "test_rule_id_1",
      "security_group_ip" => "test_group_id_1",
      "direction"         => "ingress",
      "protocol"          => "tcp",
      "ethertype"         => "IPv4",
      "port_range_max"    => "443",
      "port_range_min"    => "443",
      "remote_ip_prefix"  => "10.0.0.0/24",
      "remote_group_id"   => nil,
      "tenant_id"         => "test_tenant"
    }

    rule = Yao::SecurityGroupRule.new(params)
    assert_equal("test_rule_id_1", rule.id)
    assert_equal("tcp", rule.protocol)
    assert_equal("443", rule.port_range_max)
    assert_equal("443", rule.port_range_min)
    assert_equal("IPv4", rule.ethertype)
  end
end
