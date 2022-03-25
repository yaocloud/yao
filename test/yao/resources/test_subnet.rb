class TestSubnet < TestYaoResource

  def test_subnet
    # https://docs.openstack.org/api-ref/network/v2/#subnets
    params = {
      "name" => "private-subnet",
      "enable_dhcp" => true,
      "network_id" => "db193ab3-96e3-4cb3-8fc5-05f4296d0324",
      "segment_id" => nil,
      "project_id" => "26a7980765d0414dbc1fc1f88cdb7e6e",
      "tenant_id" => "26a7980765d0414dbc1fc1f88cdb7e6e",
      "dns_nameservers" => [],
      "dns_publish_fixed_ip" => false,
      "allocation_pools" => [
        {
          "start" => "10.0.0.2",
          "end" => "10.0.0.254"
        }
      ],
      "host_routes" => [],
      "ip_version" => 4,
      "gateway_ip" => "10.0.0.1",
      "cidr" => "10.0.0.0/24",
      "id" => "08eae331-0402-425a-923c-34f7cfe39c1b",
      "created_at" => "2016-10-10T14:35:34Z",
      "description" => "",
      "ipv6_address_mode" => nil,
      "ipv6_ra_mode" => nil,
      "revision_number" => 2,
      "service_types" => [],
      "subnetpool_id" => nil,
      "tags" => ["tag1,tag2"],
      "updated_at" => "2016-10-10T14:35:34Z"
    }

    subnet = Yao::Subnet.new(params)

    # friendly_attributes
    assert_equal("private-subnet", subnet.name)
    assert_equal("10.0.0.0/24", subnet.cidr)
    assert_equal("10.0.0.1", subnet.gateway_ip)
    assert_equal("db193ab3-96e3-4cb3-8fc5-05f4296d0324", subnet.network_id)
    assert_equal("26a7980765d0414dbc1fc1f88cdb7e6e", subnet.tenant_id)
    assert_equal(4, subnet.ip_version)
    assert_equal([], subnet.dns_nameservers)
    assert_equal([], subnet.host_routes)
    assert_equal(true, subnet.enable_dhcp)
    assert_equal(true, subnet.dhcp_enabled?) # alias

    # #allocation_pools
    assert_equal(["10.0.0.2".."10.0.0.254"], subnet.allocation_pools)
  end

  def test_network
    stub = stub_request(:get, "https://example.com:12345/networks/00000000-0000-0000-0000-000000000000").
      to_return(
       status: 200,
       body: <<-JSON,
        {
          "network": {
            "id": "00000000-0000-0000-0000-000000000000"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    params = {
      "network_id" => "00000000-0000-0000-0000-000000000000",
    }

    subnet = Yao::Subnet.new(params)
    assert_instance_of(Yao::Resources::Network, subnet.network)
    assert_equal("00000000-0000-0000-0000-000000000000", subnet.network.id)

    assert_requested(stub)
  end

  def test_project
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

    subnet = Yao::Subnet.new('project_id' => '0123456789abcdef0123456789abcdef')
    assert_instance_of(Yao::Project, subnet.project)
    assert_equal('0123456789abcdef0123456789abcdef', subnet.project.id)

    assert_requested(stub)
  end
end
