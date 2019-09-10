class TestFlavor < TestYaoResource

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
    assert_equal("1", flavor.id)
    assert_equal("m1.tiny", flavor.name)
    assert_equal(1, flavor.vcpus)
    assert_equal(1, flavor.disk)
    assert_equal("", flavor.swap)

    # map_attribute_to_attribute
    assert_equal(true, flavor.public?)
    assert_equal(false, flavor.disabled?)

    assert_equal(512, flavor.ram)
    assert_equal(512, flavor.ram('M'))
    assert_equal(0.5, flavor.ram('G'))
    assert_equal(512, flavor.memory)
  end

  def test_list
    stub = stub_request(:get, "https://example.com:12345/flavors/detail").
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

    assert(Yao::Flavor.resources_detail_available)

    flavors = Yao::Flavor.list
    assert_instance_of(Yao::Flavor, flavors.first)
    assert_equal("m1.tiny", flavors.first.name)

    assert_requested(stub)
  end

  def test_list_detail
    # Yao::Flavor.list_detail と Yao::Flavor.list が alias にあることをテストする
    # see also: https://stackoverflow.com/questions/25883618/how-to-test-method-alias-ruby
    assert_equal(Yao::Flavor.method(:list), Yao::Flavor.method(:list_detail))
  end
end
