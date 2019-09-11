class TestImage < TestYaoResource

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
