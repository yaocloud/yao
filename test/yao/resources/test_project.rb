class TestProject < TestYaoResource
  def setup
    super
    Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v2.0")
  end

  # https://docs.openstack.org/api-ref/identity/v3/?expanded=list-projects-detail#projects
  def test_project
    params = {
      "is_domain" => false,
      "description" => nil,
      "domain_id" => "default",
      "enabled" => true,
      "id" => "0c4e939acacf4376bdcd1129f1a054ad",
      "links" => {
        "self" => "http://example.com/identity/v3/projects/0c4e939acacf4376bdcd1129f1a054ad"
      },
      "name" => "admin",
      "parent_id" => nil,
      "tags" => []
    }

    project = Yao::Project.new(params)
    assert_equal(false, project.domain?)
    assert_equal(nil, project.description)
    assert_equal("default", project.domain_id)
    assert_equal(true, project.enabled?)
    assert_equal("0c4e939acacf4376bdcd1129f1a054ad", project.id)
    assert_equal("admin", project.name)
    assert_equal(nil, project.parent_id)
  end

  def test_ports
    stub = stub_request(:get, "https://example.com:12345/ports?tenant_id=d397de8a63f341818f198abb0966f6f3")
               .to_return(
                   status: 200,
                   # https://docs.openstack.org/api-ref/network/v2/?expanded=list-floating-ips-detail,list-ports-detail#list-ports
                   body: <<-JSON,
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
                           },
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
                               "device_owner": "network:router_interface",
                               "dns_assignment": {
                                   "hostname": "myport2",
                                   "ip_address": "10.0.0.1",
                                   "fqdn": "myport2.my-domain.org"
                               },
                               "dns_domain": "my-domain.org.",
                               "dns_name": "myport2",
                               "extra_dhcp_opts": [],
                               "fixed_ips": [
                                   {
                                       "ip_address": "10.0.0.1",
                                       "subnet_id": "288bf4a1-51ba-43b6-9d0a-520e9005db17"
                                   }
                               ],
                               "id": "f71a6703-d6de-4be1-a91a-a570ede1d159",
                               "ip_allocation": "immediate",
                               "mac_address": "fa:16:3e:bb:3c:e4",
                               "name": "",
                               "network_id": "f27aa545-cbdd-4907-b0c6-c9e8b039dcc2",
                               "port_security_enabled": true,
                               "project_id": "d397de8a63f341818f198abb0966f6f3",
                               "revision_number": 2,
                               "security_groups": [],
                               "status": "ACTIVE",
                               "tenant_id": "d397de8a63f341818f198abb0966f6f3",
                               "updated_at": "2016-03-08T20:19:41",
                               "qos_policy_id": null,
                               "tags": ["tag1,tag2"],
                               "tenant_id": "d397de8a63f341818f198abb0966f6f3",
                               "uplink_status_propagation": false
                           }
                       ]
                   }
                   JSON
                   headers: {'Content-Type' => 'application/json'}
               )
    params = {
        "id" => "d397de8a63f341818f198abb0966f6f3",
    }
    project = Yao::Project.new(params)
    assert_instance_of(Array, project.ports)
    assert_requested(stub)
  end

  def test_servers
    stub = stub_request(:get, "https://example.com:12345/servers/detail?all_tenants=1&project_id=6f70656e737461636b20342065766572")
               .to_return(
                   status: 200,
                   # https://docs.openstack.org/api-ref/compute/?expanded=list-servers-detailed-detail#list-servers-detailed
                   body: <<-JSON,
                   {
                       "servers": [
                           {
                               "OS-DCF:diskConfig": "AUTO",
                               "OS-EXT-AZ:availability_zone": "nova",
                               "OS-EXT-SRV-ATTR:host": "compute",
                               "OS-EXT-SRV-ATTR:hostname": "new-server-test",
                               "OS-EXT-SRV-ATTR:hypervisor_hostname": "fake-mini",
                               "OS-EXT-SRV-ATTR:instance_name": "instance-00000001",
                               "OS-EXT-SRV-ATTR:kernel_id": "",
                               "OS-EXT-SRV-ATTR:launch_index": 0,
                               "OS-EXT-SRV-ATTR:ramdisk_id": "",
                               "OS-EXT-SRV-ATTR:reservation_id": "r-l0i0clt2",
                               "OS-EXT-SRV-ATTR:root_device_name": "/dev/sda",
                               "OS-EXT-SRV-ATTR:user_data": "IyEvYmluL2Jhc2gKL2Jpbi9zdQplY2hvICJJIGFtIGluIHlvdSEiCg==",
                               "OS-EXT-STS:power_state": 1,
                               "OS-EXT-STS:task_state": null,
                               "OS-EXT-STS:vm_state": "active",
                               "OS-SRV-USG:launched_at": "2019-04-23T15:19:15.317839",
                               "OS-SRV-USG:terminated_at": null,
                               "accessIPv4": "1.2.3.4",
                               "accessIPv6": "80fe::",
                               "addresses": {
                                   "private": [
                                       {
                                           "OS-EXT-IPS-MAC:mac_addr": "00:0c:29:0d:11:74",
                                           "OS-EXT-IPS:type": "fixed",
                                           "addr": "192.168.1.30",
                                           "version": 4
                                       }
                                   ]
                               },
                               "config_drive": "",
                               "created": "2019-04-23T15:19:14Z",
                               "description": null,
                               "flavor": {
                                   "disk": 1,
                                   "ephemeral": 0,
                                   "extra_specs": {},
                                   "original_name": "m1.tiny",
                                   "ram": 512,
                                   "swap": 0,
                                   "vcpus": 1
                               },
                               "hostId": "2091634baaccdc4c5a1d57069c833e402921df696b7f970791b12ec6",
                               "host_status": "UP",
                               "id": "2ce4c5b3-2866-4972-93ce-77a2ea46a7f9",
                               "image": {
                                   "id": "70a599e0-31e7-49b7-b260-868f441e862b",
                                   "links": [
                                       {
                                           "href": "http://openstack.example.com/6f70656e737461636b20342065766572/images/70a599e0-31e7-49b7-b260-868f441e862b",
                                           "rel": "bookmark"
                                       }
                                   ]
                               },
                               "key_name": null,
                               "links": [
                                   {
                                       "href": "http://openstack.example.com/v2.1/6f70656e737461636b20342065766572/servers/2ce4c5b3-2866-4972-93ce-77a2ea46a7f9",
                                       "rel": "self"
                                   },
                                   {
                                       "href": "http://openstack.example.com/6f70656e737461636b20342065766572/servers/2ce4c5b3-2866-4972-93ce-77a2ea46a7f9",
                                       "rel": "bookmark"
                                   }
                               ],
                               "locked": true,
                               "locked_reason": "I don't want to work",
                               "metadata": {
                                   "My Server Name": "Apache1"
                               },
                               "name": "new-server-test",
                               "os-extended-volumes:volumes_attached": [],
                               "progress": 0,
                               "security_groups": [
                                   {
                                       "name": "default"
                                   }
                               ],
                               "status": "ACTIVE",
                               "tags": [],
                               "tenant_id": "6f70656e737461636b20342065766572",
                               "trusted_image_certificates": null,
                               "updated": "2019-04-23T15:19:15Z",
                               "user_id": "fake"
                           }
                       ]
                   }
                   JSON
                   headers: {'Content-Type' => 'application/json'}
               )
    params = {
        "id" => "6f70656e737461636b20342065766572",
    }
    project = Yao::Project.new(params)
    assert_instance_of(Array, project.servers)
    assert_requested(stub)
  end

  def test_server_usage
    stub = stub_request(:get, "https://example.com:12345/os-simple-tenant-usage/0123456789abcdef0123456789abcdef")
      .to_return(
         status: 200,
         body: <<-JSON,
        {
            "tenant_usage": {
                "total_memory_mb_usage": 1024
            }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    project = Yao::Project::new("id" => "0123456789abcdef0123456789abcdef")
    usage = project.server_usage
    assert_equal(1024, usage["total_memory_mb_usage"])
  end
end
