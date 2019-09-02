class TestFlavor < TestYaoResouce

  def test_flavor
    # https://docs.openstack.org/api-ref/compute/?expanded=list-flavors-detail,list-flavors-with-details-detail#list-flavors-with-details
    params = {
      "OS-FLV-DISABLED:disabled" => false,
      "disk" => 1,
      "OS-FLV-EXT-DATA:ephemeral" => 0,
      "os-flavor-access:is_public" => true,
      "id" => "1",
      "links" => [
        {
          "href" => "http://openstack.example.com/v2/6f70656e737461636b20342065766572/flavors/1",
          "rel" => "self"
        },
        {
          "href" => "http://openstack.example.com/6f70656e737461636b20342065766572/flavors/1",
          "rel" => "bookmark"
        }
      ],
      "name" => "m1.tiny",
      "ram" => 512,
      "swap" => "",
      "vcpus" => 1,
      "rxtx_factor" => 1.0,
      "description" => nil,
      "extra_specs" => {}
    }

    flavor = Yao::Flavor.new(params)

    # friendly_attributes
    assert_equal(flavor.id, "1")
    assert_equal(flavor.name, "m1.tiny")
    assert_equal(flavor.vcpus, 1)
    assert_equal(flavor.disk, 1)
    assert_equal(flavor.swap, "")

    # map_attribute_to_attribute
    assert_equal(flavor.public?, true)
    assert_equal(flavor.disabled?, false)

    assert_equal(flavor.ram, 512)
    assert_equal(flavor.ram('M'), 512)
    assert_equal(flavor.ram('G'), 0.5)
    assert_equal(flavor.memory, 512)
  end

  def test_list_detail
    stub_request(:get, "https://example.com:12345/flavors/detail").
      to_return(
        status: 200,
        body: <<-JSON,
        {
            "flavors": [
                {
                    "OS-FLV-DISABLED:disabled": false,
                    "disk": 1,
                    "OS-FLV-EXT-DATA:ephemeral": 0,
                    "os-flavor-access:is_public": true,
                    "id": "1",
                    "links": [
                        {
                            "href": "http://openstack.example.com/v2/6f70656e737461636b20342065766572/flavors/1",
                            "rel": "self"
                        },
                        {
                            "href": "http://openstack.example.com/6f70656e737461636b20342065766572/flavors/1",
                            "rel": "bookmark"
                        }
                    ],
                    "name": "m1.tiny",
                    "ram": 512,
                    "swap": "",
                    "vcpus": 1,
                    "rxtx_factor": 1.0,
                    "description": null,
                    "extra_specs": {}
                }
            ]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    flavors = Yao::Flavor.list_detail
    assert { flavors.first.instance_of? Yao::Flavor }
    assert_equal(flavors.first.name, "m1.tiny")
  end
end
