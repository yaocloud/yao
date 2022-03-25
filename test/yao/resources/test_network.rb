class TestNetwork < TestYaoResource
  include RestfullyAccessibleStub

  def test_network

    # https://docs.openstack.org/api-ref/network/v2/#networks
    params = {
      "admin_state_up" => true,
      "id" => "b3680498-03da-4691-896f-ef9ee1d856a7",
      "name" => "net1",
      "provider:network_type" => "vlan",
      "provider:physical_network" => "physnet1",
      "provider:segmentation_id" => 1000,
      "router:external" => false,
      "shared" => false,
      "status" => "ACTIVE",
      "subnets" => [],
      "tenant_id" => "c05140b3dc7c4555afff9fab6b58edc2",
      "project_id" => "c05140b3dc7c4555afff9fab6b58edc2",
    }

    network = Yao::Network.new(params)

    # friendly_attributes
    assert_equal("b3680498-03da-4691-896f-ef9ee1d856a7", network.id)
    assert_equal("net1", network.name)
    assert_equal("ACTIVE", network.status)
    assert_equal(false, network.shared)
    assert_equal(false, network.shared?)
    assert_equal("c05140b3dc7c4555afff9fab6b58edc2", network.tenant_id)
    assert_equal([], network.subnets)
    assert_equal(true, network.admin_state_up)

    #map_attribute_to_attribute
    assert_equal("physnet1", network.physical_network)
    assert_equal("vlan", network.type)
    assert_equal(1000, network.segmentation_id)
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

    network = Yao::Network.new(
      "project_id" => "0123456789abcdef0123456789abcdef",
      "tenant_id"  => "0123456789abcdef0123456789abcdef",
    )

    assert_instance_of(Yao::Project, network.tenant)
    assert_instance_of(Yao::Project, network.project)
    assert_equal('0123456789abcdef0123456789abcdef', network.project.id)

    assert_requested(stub)
  end

  def test_ports
    network_id = "d80b1a3b-4fc1-49f3-952e-1e2ab7081d8b"
    # https://docs.openstack.org/api-ref/network/v2/?expanded=list-floating-ips-detail,list-ports-detail#list-ports
    body = <<-JSON
    {
      "ports": [
          {
              "admin_state_up": true,
              "allowed_address_pairs": [],
              "binding:host_id": "devstack",
              "binding:profile": {},
              "binding:vif_details": {
                  "ovs_hybrid_plug": true,
                  "port_filter": true
              },
              "binding:vif_type": "ovs",
              "binding:vnic_type": "normal",
              "created_at": "2016-03-08T20:19:41",
              "data_plane_status": null,
              "description": "",
              "device_id": "9ae135f4-b6e0-4dad-9e91-3c223e385824",
              "device_owner": "network:router_gateway",
              "dns_assignment": {
                  "hostname": "myport",
                  "ip_address": "172.24.4.2",
                  "fqdn": "myport.my-domain.org"
              },
              "dns_domain": "my-domain.org.",
              "dns_name": "myport",
              "extra_dhcp_opts": [],
              "fixed_ips": [
                  {
                      "ip_address": "172.24.4.2",
                      "subnet_id": "008ba151-0b8c-4a67-98b5-0d2b87666062"
                  }
              ],
              "id": "d80b1a3b-4fc1-49f3-952e-1e2ab7081d8b",
              "ip_allocation": "immediate",
              "mac_address": "fa:16:3e:58:42:ed",
              "name": "",
              "network_id": "70c1db1f-b701-45bd-96e0-a313ee3430b3",
              "port_security_enabled": true,
              "project_id": "",
              "revision_number": 1,
              "security_groups": [],
              "status": "ACTIVE",
              "tenant_id": "",
              "updated_at": "2016-03-08T20:19:41",
              "qos_policy_id": "29d5e02e-d5ab-4929-bee4-4a9fc12e22ae",
              "resource_request": {
                  "required": ["CUSTOM_PHYSNET_PUBLIC", "CUSTOM_VNIC_TYPE_NORMAL"],
                  "resources": {"NET_BW_EGR_KILOBIT_PER_SEC": 1000}
              },
              "tags": ["tag1,tag2"],
              "tenant_id": "",
              "uplink_status_propagation": false
          }
        ]
      }
      JSON
    stub = stub_get_request_with_json_response("https://example.com:12345/ports?network_id=#{network_id}", body)
    network = Yao::Network.new({"id" => network_id})
    ports = network.ports
    assert_equal(ports.first.id, "d80b1a3b-4fc1-49f3-952e-1e2ab7081d8b")
    assert_requested(stub)
  end
end
