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

  def flavor_detail
    JSON.parse(<<~JSON)
      {
          "OS-FLV-DISABLED:disabled": false,
          "disk": 20,
          "OS-FLV-EXT-DATA:ephemeral": 0,
          "os-flavor-access:is_public": true,
          "id": "7",
          "links": [
              {
                  "href": "http://openstack.example.com/v2/6f70656e737461636b20342065766572/flavors/7",
                  "rel": "self"
              },
              {
                  "href": "http://openstack.example.com/6f70656e737461636b20342065766572/flavors/7",
                  "rel": "bookmark"
              }
          ],
          "name": "m1.small.description",
          "ram": 2048,
          "swap": 0,
          "vcpus": 1,
          "rxtx_factor": 1.0,
          "description": "test description",
          "extra_specs": {
              "hw:cpu_policy": "shared",
              "hw:numa_nodes": "1"
          }
      }
    JSON
  end

  def stub_flavors_detail(query=nil)
    url = ['https://example.com:12345/flavors/detail',query].compact.join('?')
    stub_request(:get, url).
      to_return(
        status: 200,
        body: { flavors:[flavor_detail] }.to_json,
        headers: {'Content-Type' => 'application/json'}
      )
  end

  def stub_flavor(id)
    stub_request(:get, "https://example.com:12345/flavors/#{id}").
      to_return(
        status: 200,
        body: { 'flavor': flavor_detail }.to_json,
        headers: {'Content-Type' => 'application/json'}
      )
  end

  def test_list
    stub = stub_flavors_detail
    assert(Yao::Flavor.resources_detail_available)

    flavors = Yao::Flavor.list
    assert_instance_of(Yao::Flavor, flavors.first)
    assert_equal("m1.small.description", flavors.first.name)

    assert_requested(stub)
  end

  def test_list_detail
    # Yao::Flavor.list_detail と Yao::Flavor.list が alias にあることをテストする
    # see also: https://stackoverflow.com/questions/25883618/how-to-test-method-alias-ruby
    assert_equal(Yao::Flavor.method(:list), Yao::Flavor.method(:list_detail))
  end

  def test_get_by_id
    stub = stub_flavor(7)
    flavor = Yao::Flavor.get('7')
    assert_equal('m1.small.description', flavor.name)
    assert_requested(stub)
  end

  def test_get_by_name
    stub = stub_request(:get, "https://example.com:12345/flavors/m1.small.description").to_return(status: 404)
    stub2 = stub_flavors_detail
    stub3 = stub_flavor(7)
    flavor = Yao::Flavor.get('m1.small.description')
    assert_equal('7', flavor.id)
    assert_requested(stub)
    assert_requested(stub2)
    assert_requested(stub3)
  end
end
