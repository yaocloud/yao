class TestVolume < TestYaoResource
  def test_volume
    params = {
        'attachments' => [],
        'availability_zone' => 'test',
        'bootable' => true,
        'encrypted' => false,
        'metadata' => {},
        'multiattach' => false,
        'name' => 'cinder',
        'replication_status' => 'disabled',
        'size' => 10,
        'snapshot_id' => nil,
        'status' => 'available',
        'user_id' => 'aaaa166533fd49f3b11b1cdce2430000',
        'volume_type' => 'test'
    }

    volume = Yao::Volume.new(params)
    assert_equal(volume.attachments, [])
    assert_equal(volume.availability_zone, 'test')
    assert_equal(volume.bootable, true)
    assert_equal(volume.encrypted, false)
    assert_equal(volume.metadata, {})
    assert_equal(volume.multiattach, false)
    assert_equal(volume.name, 'cinder')
    assert_equal(volume.replication_status, 'disabled')
    assert_equal(volume.size, 10)
    assert_equal(volume.snapshot_id, nil)
    assert_equal(volume.user_id, 'aaaa166533fd49f3b11b1cdce2430000')
    assert_equal(volume.volume_type, 'test')
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
