class TestSecurityGroup < Test::Unit::TestCase
  def test_sg_attributes
    params = {
      "id"                   => "test_group_id_1",
      "name"                 => "test_group_name_1",
      "description"          => "test_description_1",
      "security_group_rules" => [
        {
          "id"        => "test_rule_id_1",
          "direction" => "ingress",
          "protocol"  => "tcp",
          "ethertype" => "IPv4",
          "port"      =>  "443",
          "remote_ip" => "10.0.0.0/24"
        }
      ]
    }

    sg = Yao::SecurityGroup.new(params)
    assert_equal(sg.name, "test_group_name_1")
    assert_equal(sg.id, "test_group_id_1")
    assert_equal(sg.description, "test_description_1")
    assert(sg.rules[0].instance_of?(Yao::SecurityGroupRule))
  end
end
