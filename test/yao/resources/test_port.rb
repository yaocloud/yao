class TestPort < Test::Unit::TestCase

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
    assert_equal(port.id, "46d4bfb9-b26e-41f3-bd2e-e6dcc1ccedb2")

    # friendly_attributes
    assert_equal(port.name, "foobar")
    assert_equal(port.mac_address, "fa:16:3e:23:fd:d7")
    assert_equal(port.status, "ACTIVE")
    assert_equal(port.allowed_address_pairs, [])
    assert_equal(port.device_owner, "network:router_interface")
    assert_equal(port.fixed_ips, [
      {
        "ip_address" => "10.0.0.1",
        "subnet_id" => "a0304c3a-4f08-4c43-88af-d796509c97d2"
      }
    ])
    assert_equal(port.security_groups, [])
    assert_equal(port.device_id, "5e3898d7-11be-483e-9732-b2f5eccd2b2e")
    assert_equal(port.network_id, "a87cc70a-3e15-4acf-8205-9b711a3531b7")
    assert_equal(port.tenant_id, "7e02058126cc4950b75f9970368ba177")
    assert_equal(port.admin_state_up, true)

    # map_attribute_to_attribute
    assert_equal(port.host_id, "compute-000")

    # primary_ip
    assert_equal(port.primary_ip, "10.0.0.1")
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
    assert_equal(port.primary_ip, "10.0.0.1")
  end
end
