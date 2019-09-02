class TestSample < TestYaoResouce

  def test_sample

    # https://docs.openstack.org/ceilometer/pike/webapi/v2.html#Sample
    params = {
      "id" => "2e589cbc-738f-11e9-a9b2-bc764e200515",
      "metadata" => {
        "name1" => "value1",
        "name2" => "value2"
      },
      "meter" => "instance",
      "project_id" => "35b17138-b364-4e6a-a131-8f3099c5be68",
      "recorded_at" => "2015-01-01T12:00:00",
      "resource_id" => "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
      "source" => "openstack",
      "timestamp" => "2015-01-01T12:00:00",
      "type" => "gauge",
      "unit" => "instance",
      "user_id" => "efd87807-12d2-4b38-9c70-5f5c2ac427ff",
      "volume" => 1.0
    }

    sample = Yao::Resources::Sample.new(params)
    assert_equal(sample.id, "2e589cbc-738f-11e9-a9b2-bc764e200515")
    assert_equal(sample.metadata, {
      "name1" => "value1",
      "name2" => "value2"
    })
    assert_equal(sample.meter, "instance")
    assert_equal(sample.source, "openstack")
    assert_equal(sample.type, "gauge")
    assert_equal(sample.unit, "instance")
    assert_equal(sample.volume, 1.0)
    assert_equal(sample.resource_id, "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36")
    assert_equal(sample.user_id, "efd87807-12d2-4b38-9c70-5f5c2ac427ff")
    assert_equal(sample.recorded_at, Time.parse("2015-01-01T12:00:00"))
    assert_equal(sample.timestamp, Time.parse("2015-01-01T12:00:00"))
  end

  def test_resource

    # https://docs.openstack.org/ceilometer/pike/webapi/v2.html
    stub_request(:get, "https://example.com:12345/v2/resources/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
            "resource_id": "00000000-0000-0000-0000-000000000000"
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    sample = Yao::Resources::Sample.new( 'resource_id' => '00000000-0000-0000-0000-000000000000' )
    assert_instance_of(Yao::Resources::Resource, sample.resource)
    assert_equal(sample.resource.id, "00000000-0000-0000-0000-000000000000")
  end
end
