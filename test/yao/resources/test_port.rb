class TestPort < TestYaoResource

  def test_port

    # https://docs.openstack.org/api-ref/network/v2/?expanded=list-floating-ips-detail,show-port-details-detail#ports
    params = {
      "admin_state_up" => true,
      "allowed_address_pairs" => [],
      "created_at" => "2016-03-08T20:19:41",
      "data_plane_status" => "ACTIVE",
      "description" => "",
      "device_id" => "5e3898d7-11be-483e-9732-b2f5eccd2b2e",
      "device_owner" => "network:router_interface",
      "dns_assignment" => {
        "hostname" => "myport",
        "ip_address" => "10.0.0.1",
        "fqdn" => "myport.my-domain.org"
      },
      "dns_domain" => "my-domain.org.",
      "dns_name" => "myport",
      "extra_dhcp_opts" => [
        {
          "opt_value" => "pxelinux.0",
          "ip_version" => 4,
          "opt_name" => "bootfile-name"
        }
      ],
      "fixed_ips" => [
        {
          "ip_address" => "10.0.0.1",
          "subnet_id" => "a0304c3a-4f08-4c43-88af-d796509c97d2"
        }
      ],
      "id" => "46d4bfb9-b26e-41f3-bd2e-e6dcc1ccedb2",
      "ip_allocation" => "immediate",
      "mac_address" => "fa:16:3e:23:fd:d7",
      "name" => "foobar",
      "network_id" => "a87cc70a-3e15-4acf-8205-9b711a3531b7",
      "port_security_enabled" => false,
      "project_id" => "7e02058126cc4950b75f9970368ba177",
      "revision_number" => 1,
      "security_groups" => [],
      "status" => "ACTIVE",
      "tags" => ["tag1,tag2"],
      "tenant_id" => "7e02058126cc4950b75f9970368ba177",
      "updated_at" => "2016-03-08T20:19:41",
      "qos_policy_id" => "29d5e02e-d5ab-4929-bee4-4a9fc12e22ae",
      "uplink_status_propagation" => false,
      "binding:host_id" => "compute-000",
    }

    port = Yao::Port.new(params)
    assert_equal("46d4bfb9-b26e-41f3-bd2e-e6dcc1ccedb2", port.id)

    # friendly_attributes
    assert_equal("foobar", port.name)
    assert_equal("fa:16:3e:23:fd:d7", port.mac_address)
    assert_equal("ACTIVE", port.status)
    assert_equal([], port.allowed_address_pairs)
    assert_equal("network:router_interface", port.device_owner)
    assert_equal([
      {
        "ip_address" => "10.0.0.1",
        "subnet_id" => "a0304c3a-4f08-4c43-88af-d796509c97d2"
      }
    ], port.fixed_ips)
    assert_equal([], port.security_groups)
    assert_equal("5e3898d7-11be-483e-9732-b2f5eccd2b2e", port.device_id)
    assert_equal("a87cc70a-3e15-4acf-8205-9b711a3531b7", port.network_id)
    assert_equal("7e02058126cc4950b75f9970368ba177", port.tenant_id)
    assert_equal(true, port.admin_state_up)

    # map_attribute_to_attribute
    assert_equal("compute-000", port.host_id)

    # primary_ip
    assert_equal("10.0.0.1", port.primary_ip)
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

    port = Yao::Port.new('project_id' => '0123456789abcdef0123456789abcdef')
    assert_instance_of(Yao::Project, port.project)
    assert_equal('0123456789abcdef0123456789abcdef', port.project.id)

    assert_requested(stub)
  end

  def test_primary_ip

    params = {
      "fixed_ips" => [
        {
          "ip_address" => "10.0.0.1",
          "subnet_id" => "a0304c3a-4f08-4c43-88af-d796509c97d2"
        }
      ],
    }

    port = Yao::Port.new(params)
    assert_equal("10.0.0.1", port.primary_ip)
  end

  def test_primary_subnet

    stub = stub_request(:get, "https://example.com:12345/subnets/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "subnet": {
            "id": "00000000-0000-0000-0000-000000000000"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    params = {
      "fixed_ips" => [
        {
          "ip_address" => "10.0.0.1",
          "subnet_id" => "00000000-0000-0000-0000-000000000000"
        }
      ],
    }

    port = Yao::Port.new(params)
    assert{ port.primary_subnet.instance_of?(Yao::Subnet) }
    assert_equal("00000000-0000-0000-0000-000000000000", port.primary_subnet.id)

    assert_requested(stub)
  end

  def test_network

    stub = stub_request(:get, "https://example.com:12345/networks/00000000-0000-0000-0000-000000000000")
      .to_return(
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

    port = Yao::Port.new(params)
    assert_instance_of(Yao::Network, port.network)
    assert_equal("00000000-0000-0000-0000-000000000000", port.network.id)

    assert_requested(stub)
  end
end
