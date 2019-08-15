class TestServer < Test::Unit::TestCase

  def setup
    Yao.default_client.pool["compute"] = Yao::Client.gen_client("https://example.com:12345")
  end

  def test_server

    # https://docs.openstack.org/api-ref/compute/?expanded=list-servers-detail,list-servers-detailed-detail#list-servers
    params = {
      "OS-DCF:diskConfig" => "AUTO",
      "OS-EXT-AZ:availability_zone" => "nova",
      "OS-EXT-SRV-ATTR:host" => "compute",
      "OS-EXT-SRV-ATTR:hostname" => "new-server-test",
      "OS-EXT-SRV-ATTR:hypervisor_hostname" => "fake-mini",
      "OS-EXT-SRV-ATTR:instance_name" => "instance-00000001",
      "OS-EXT-SRV-ATTR:kernel_id" => "",
      "OS-EXT-SRV-ATTR:launch_index" => 0,
      "OS-EXT-SRV-ATTR:ramdisk_id" => "",
      "OS-EXT-SRV-ATTR:reservation_id" => "r-l0i0clt2",
      "OS-EXT-SRV-ATTR:root_device_name" => "/dev/sda",
      "OS-EXT-SRV-ATTR:user_data" => "IyEvYmluL2Jhc2gKL2Jpbi9zdQplY2hvICJJIGFtIGluIHlvdSEiCg==",
      "OS-EXT-STS:power_state" => 1,
      "OS-EXT-STS:task_state" => nil,
      "OS-EXT-STS:vm_state" => "active",
      "OS-SRV-USG:launched_at" => "2019-04-23T15:19:15.317839",
      "OS-SRV-USG:terminated_at" => nil,
      "accessIPv4" => "1.2.3.4",
      "accessIPv6" => "80fe::",
      "addresses" => {
        "private" => [
          {
            "OS-EXT-IPS-MAC:mac_addr" => "aa:bb:cc:dd:ee:ff",
            "OS-EXT-IPS:type" => "fixed",
            "addr" => "192.168.0.3",
            "version" => 4
          }
        ]
      },
      "config_drive" => "",
      "created" => "2019-04-23T15:19:14Z",
      "description" => nil,
      "flavor" => {
        "disk" => 1,
        "ephemeral" => 0,
        "extra_specs" => {},
        "original_name" => "m1.tiny",
        "ram" => 512,
        "swap" => 0,
        "vcpus" => 1
      },
      "hostId" => "2091634baaccdc4c5a1d57069c833e402921df696b7f970791b12ec6",
      "host_status" => "UP",
      "id" => "2ce4c5b3-2866-4972-93ce-77a2ea46a7f9",
      "image" => {
        "id" => "70a599e0-31e7-49b7-b260-868f441e862b",
        "links" => [
          {
            "href" => "http://openstack.example.com/6f70656e737461636b20342065766572/images/70a599e0-31e7-49b7-b260-868f441e862b",
            "rel" => "bookmark"
          }
        ]
      },
      "key_name" => nil,
      "links" => [
        {
          "href" => "http://openstack.example.com/v2.1/6f70656e737461636b20342065766572/servers/2ce4c5b3-2866-4972-93ce-77a2ea46a7f9",
          "rel" => "self"
        },
        {
          "href" => "http://openstack.example.com/6f70656e737461636b20342065766572/servers/2ce4c5b3-2866-4972-93ce-77a2ea46a7f9",
          "rel" => "bookmark"
        }
      ],
      "locked" => true,
      "locked_reason" => "I don't want to work",
      "metadata" => {
        "My Server Name" => "Apache1"
      },
      "name" => "new-server-test",
      "os-extended-volumes:volumes_attached" => [],
      "progress" => 0,
      "security_groups" => [
        {
          "name" => "default"
        }
      ],
      "status" => "ACTIVE",
      "tags" => [],
      "tenant_id" => "6f70656e737461636b20342065766572",
      "trusted_image_certificates" => nil,
      "updated" => "2019-04-23T15:19:15Z",
      "user_id" => "fake"
    }

    server = Yao::Server.new(params)

    # friendly_attributes
    assert_equal(server.id, "2ce4c5b3-2866-4972-93ce-77a2ea46a7f9")
    assert_equal(server.addresses, {
      "private" => [
        {
          "OS-EXT-IPS-MAC:mac_addr" => "aa:bb:cc:dd:ee:ff",
          "OS-EXT-IPS:type" => "fixed",
          "addr" => "192.168.0.3",
          "version" => 4
        }
      ]
                 })
    assert_equal(server.metadata, { "My Server Name" => "Apache1" })
    assert_equal(server.name, "new-server-test")
    assert_equal(server.progress, 0)
    assert_equal(server.status, "ACTIVE")
    assert_equal(server.tenant_id, "6f70656e737461636b20342065766572")
    assert_equal(server.user_id, "fake")
    assert_equal(server.key_name, nil)

    # map_attribute_to_attribute
    assert_equal(server.host_id, "2091634baaccdc4c5a1d57069c833e402921df696b7f970791b12ec6")

    # map_attribute_to_resource - flavor
    assert_instance_of(Yao::Resources::Flavor, server.flavor)
    assert_equal(server.flavor.disk, 1)

    # map_attribute_to_resource - image
    assert_instance_of(Yao::Resources::Image, server.image)
    assert_equal(server.image.id, "70a599e0-31e7-49b7-b260-868f441e862b")

    # map_attribute_to_resource - security_groups
    assert_instance_of(Array, server.security_groups)
    assert_instance_of(Yao::Resources::SecurityGroup, server.security_groups.first)
    assert_equal(server.security_groups.first.name, "default")

    # map_attribute_to_attribute
    assert_equal(server.availability_zone, "nova")
    assert_equal(server.dcf_disk_config, "AUTO")
    assert_equal(server.ext_srv_attr_host, "compute")
    assert_equal(server.ext_srv_attr_hypervisor_hostname, "fake-mini")
    assert_equal(server.ext_srv_attr_instance_name, "instance-00000001")
    assert_equal(server.ext_sts_power_state, 1)
    assert_equal(server.ext_sts_task_state, nil)
    assert_equal(server.ext_sts_vm_state, "active")
  end

  def test_list_detail
    stub_request(:get, "https://example.com:12345/servers/detail")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "servers": [{
            "id": "dummy"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    servers = Yao::Server.list_detail
    assert_instance_of(Array, servers)
    assert_instance_of(Yao::Server, servers.first)
    assert_equal(servers.first.id, 'dummy')
  end
end
