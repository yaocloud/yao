class TestSecurityGroup < TestYaoResource
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
    assert_equal("test_group_name_1", sg.name)
    assert_equal("test_group_id_1", sg.id)
    assert_equal("test_description_1", sg.description)
    assert(sg.rules[0].instance_of?(Yao::SecurityGroupRule))
  end

  def test_sg_to_tenant

    stub = stub_request(:get, "https://example.com:12345/projects/0123456789abcdef0123456789abcdef")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "project": {
            "id": "0123456789abcdef0123456789abcdef"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    sg = Yao::SecurityGroup.new('project_id' => '0123456789abcdef0123456789abcdef')
    assert_instance_of(Yao::Project, sg.project)
    assert_equal('0123456789abcdef0123456789abcdef', sg.project.id)

    assert_requested(stub)
  end
end
