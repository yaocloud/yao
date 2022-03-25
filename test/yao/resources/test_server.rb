class TestServer < TestYaoResource

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
    assert_equal("2ce4c5b3-2866-4972-93ce-77a2ea46a7f9", server.id)
    assert_equal({
      "private" => [
        {
          "OS-EXT-IPS-MAC:mac_addr" => "aa:bb:cc:dd:ee:ff",
          "OS-EXT-IPS:type" => "fixed",
          "addr" => "192.168.0.3",
          "version" => 4
        }
      ]
    }, server.addresses)
    assert_equal({ "My Server Name" => "Apache1" }, server.metadata)
    assert_equal("new-server-test", server.name)
    assert_equal(0, server.progress)
    assert_equal("ACTIVE", server.status)
    assert_equal("6f70656e737461636b20342065766572", server.tenant_id)
    assert_equal("fake", server.user_id)
    assert_equal(nil, server.key_name)

    # map_attribute_to_attribute
    assert_equal("2091634baaccdc4c5a1d57069c833e402921df696b7f970791b12ec6", server.host_id)

    # map_attribute_to_resource - flavor
    assert_instance_of(Yao::Resources::Flavor, server.flavor)
    assert_equal(1, server.flavor.disk)

    # map_attribute_to_resource - image
    assert_instance_of(Yao::Resources::Image, server.image)
    assert_equal("70a599e0-31e7-49b7-b260-868f441e862b", server.image.id)

    # map_attribute_to_resource - security_groups
    assert_instance_of(Array, server.security_groups)
    assert_instance_of(Yao::Resources::SecurityGroup, server.security_groups.first)
    assert_equal("default", server.security_groups.first.name)

    # map_attribute_to_attribute
    assert_equal("nova", server.availability_zone)
    assert_equal("AUTO", server.dcf_disk_config)
    assert_equal("compute", server.ext_srv_attr_host)
    assert_equal("fake-mini", server.ext_srv_attr_hypervisor_hostname)
    assert_equal("instance-00000001", server.ext_srv_attr_instance_name)
    assert_equal(1, server.ext_sts_power_state)
    assert_equal(nil, server.ext_sts_task_state)
    assert_equal("active", server.ext_sts_vm_state)
  end

  def test_list
    stub = stub_request(:get, "https://example.com:12345/servers/detail")
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

    assert(Yao::Server.resources_detail_available)

    servers = Yao::Server.list
    assert_instance_of(Array, servers)
    assert_instance_of(Yao::Server, servers.first)
    assert_equal('dummy', servers.first.id)

    assert_requested(stub)
  end

  def test_paging
    stub = stub_request(:get, "https://example.com:12345/servers/detail")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "servers_links":[
             {
                "href":"https://example.com:12345/servers/detail",
                "rel":"next"
             }
          ],
          "servers": [{
            "id": "dummy1"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      ).times(1).then
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "servers": [{
            "id": "dummy2"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      ).times(1)

    servers = Yao::Server.list
    assert_instance_of(Array, servers)
    assert_instance_of(Yao::Server, servers.first)
    assert_equal('dummy1', servers.first.id)
    assert_equal('dummy2', servers.last.id)

    assert_requested(stub, times: 2)
  end

  def test_list_detail
    assert_equal(Yao::Server.method(:list), Yao::Server.method(:list_detail))
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

    server = Yao::Server.new('project_id' => '0123456789abcdef0123456789abcdef')
    assert_instance_of(Yao::Project, server.project)
    assert_equal('0123456789abcdef0123456789abcdef', server.project.id)

    assert_requested(stub)
  end
end
