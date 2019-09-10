class TestVolume < TestYaoResource
  def test_volume
    params = {
        'name' => 'cinder',
        'size' => 10
    }

    volume = Yao::Volume.new(params)
    assert_equal(volume.name, 'cinder')
    assert_equal(volume.size, 10)
  end

  def test_list
    # https://docs.openstack.org/api-ref/block-storage/v3/index.html?expanded=#volumes-volumes
    stub = stub_request(:get, "https://example.com:12345/volumes/detail").
      to_return(
        status: 200,
        body: <<-JSON,
        {
            "volumes": [
                {
                    "id": "00000000-0000-0000-0000-000000000000"
                }
            ]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    assert(Yao::Volume.resources_detail_available)

    volumes = Yao::Volume.list
    assert_instance_of(Yao::Volume, volumes.first)
    assert_equal("00000000-0000-0000-0000-000000000000", volumes.first.id)

    assert_requested(stub)
  end

  def test_list_detail
    assert_equal(Yao::Volume.method(:list), Yao::Volume.method(:list_detail))
  end
end
