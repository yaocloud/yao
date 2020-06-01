class TestImage < TestYaoResource
  # https://docs.openstack.org/api-ref/compute/?expanded=list-flavors-detail,list-flavors-with-details-detail,list-hosts-detail,show-host-details-detail,list-images-detail,list-images-with-details-detail#list-images-with-details
  @@params = {
    "OS-DCF:diskConfig" => "AUTO",
    "OS-EXT-IMG-SIZE:size" => 74185822,
    "created" => "2011-01-01T01:02:03Z",
    "id" => "70a599e0-31e7-49b7-b260-868f441e862b",
    "links" => [
      {
        "href" => "http://openstack.example.com/v2/6f70656e737461636b20342065766572/images/70a599e0-31e7-49b7-b260-868f441e862b",
        "rel" => "self"
      },
      {
        "href" => "http://openstack.example.com/6f70656e737461636b20342065766572/images/70a599e0-31e7-49b7-b260-868f441e862b",
        "rel" => "bookmark"
      },
      {
        "href" => "http://glance.openstack.example.com/images/70a599e0-31e7-49b7-b260-868f441e862b",
        "rel" => "alternate",
        "type" => "application/vnd.openstack.image"
      }
    ],
    "metadata" => {
      "architecture" => "x86_64",
      "auto_disk_config" => "True",
      "kernel_id" => "nokernel",
      "ramdisk_id" => "nokernel"
    },
    "minDisk" => 0,
    "minRam" => 0,
    "name" => "fakeimage7",
    "progress" => 100,
    "status" => "ACTIVE",
    "updated" => "2011-01-01T01:02:03Z"
  }

  def test_image

    image = Yao::Resources::Image.new(@@params)
    check_image(image)

  end

  def test_to_hash
    server = Yao::Resources::Server.new(
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
    )

    assert_equal(server.image.to_hash, server['image__Yao::Resources::Image'].to_hash)

    image = Yao::Resources::Image.new(@@params)
    assert_equal(image.to_hash, @@params)
  end

  private

  def check_image(image)
    # friendly_attributes
    assert_equal("fakeimage7", image.name)
    assert_equal("ACTIVE", image.status)
    assert_equal(100, image.progress)
    assert_equal({
      "architecture"     => "x86_64",
      "auto_disk_config" => "True",
      "kernel_id"  => "nokernel",
      "ramdisk_id" => "nokernel"
    },image.metadata)

    # map_attribute_to_attribute
    assert_equal(0, image.min_disk)
    assert_equal(0, image.min_ram)

    assert_equal(image["OS-EXT-IMG-SIZE:size"], image.size)
    assert_equal(74185822, image.size)
    assert_equal(72447.091796875, image.size('K'))      # oops
    assert_equal(70.74911308288574, image.size('M'))    #
    assert_equal(0.06909093074500561, image.size('G'))  #
  end

end
