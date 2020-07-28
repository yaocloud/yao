class TestVolume < TestYaoResource
  def test_volume
    # https://docs.openstack.org/api-ref/block-storage/v3/index.html?expanded=show-a-volume-s-details-detail#show-a-volume-s-details
    params = {
      "attachments" => [],
      "availability_zone" => "nova",
      "bootable" => "false",
      "consistencygroup_id" => nil,
      "created_at" => "2018-11-29T06:50:07.770785",
      "description" => "description",
      "encrypted" => false,
      "id" => "f7223234-1afc-4d19-bfa3-d19deb6235ef",
      "links" => [
        {
          "href" => "http://127.0.0.1:45839/v3/89afd400-b646-4bbc-b12b-c0a4d63e5bd3/volumes/f7223234-1afc-4d19-bfa3-d19deb6235ef",
          "rel" => "self"
        },
        {
          "href" => "http://127.0.0.1:45839/89afd400-b646-4bbc-b12b-c0a4d63e5bd3/volumes/f7223234-1afc-4d19-bfa3-d19deb6235ef",
          "rel" => "bookmark"
        }
      ],
      "metadata" => {},
      "migration_status" => nil,
      "multiattach" => false,
      "name" => "cinder",
      "os-vol-host-attr:host" => "test",
      "os-vol-mig-status-attr:migstat" => nil,
      "os-vol-mig-status-attr:name_id" => nil,
      "os-vol-tenant-attr:tenant_id" => "89afd400-b646-4bbc-b12b-c0a4d63e5bd3",
      "replication_status" => nil,
      "size" => 10,
      "snapshot_id" => nil,
      "source_volid" => nil,
      "status" => "creating",
      "updated_at" => nil,
      "user_id" => "c853ca26-e8ea-4797-8a52-ee124a013d0e",
      "volume_type" => "__DEFAULT__",
      "volume_image_metadata" => {}
    }

    volume = Yao::Volume.new(params)
    assert_equal(volume.attachments, [])
    assert_equal(volume.bootable?, false)
    assert_equal(volume.description, "description")
    assert_equal(volume.error?, false)
    assert_equal(volume.encrypted?, false)
    assert_equal(volume.host, "test")
    assert_equal(volume.use?, false)
    assert_equal(volume.metadata, {})
    assert_equal(volume.migration_status, nil)
    assert_equal(volume.multiattach?, false)
    assert_equal(volume.name, 'cinder')
    assert_equal(volume.size, 10)
    assert_equal(volume.status, "creating")
    assert_equal(volume.type, "__DEFAULT__")
    assert_equal(volume.volume_image_metadata, {})
    assert_equal(volume.volume_type, "__DEFAULT__")

    volume = Yao::Volume.new({"status" => "in-use"})
    assert_equal(volume.use?, true)

    volume = Yao::Volume.new({"status" => "error"})
    assert_equal(volume.error?, true)
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
