class TestImage < Test::Unit::TestCase

  def test_image

    # https://docs.openstack.org/api-ref/compute/?expanded=list-flavors-detail,list-flavors-with-details-detail,list-hosts-detail,show-host-details-detail,list-images-detail,list-images-with-details-detail#list-images-with-details
    params = {
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

    image = Yao::Image.new(params)

    # friendly_attributes
    assert_equal(image.name, "fakeimage7")
    assert_equal(image.status, "ACTIVE")
    assert_equal(image.progress, 100)
    assert_equal(image.metadata, {
      "architecture"     => "x86_64",
      "auto_disk_config" => "True",
      "kernel_id"  => "nokernel",
      "ramdisk_id" => "nokernel"
    })

    # map_attribute_to_attribute
    assert_equal(image.min_disk, 0)
    assert_equal(image.min_ram, 0)

    assert_equal(image.size, image["OS-EXT-IMG-SIZE:size"])
    assert_equal(image.size, 74185822)
    assert_equal(image.size('K'), 72447.091796875)      # oops
    assert_equal(image.size('M'), 70.74911308288574)    #
    assert_equal(image.size('G'), 0.06909093074500561)  #
  end
end
