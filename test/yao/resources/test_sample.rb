class TestSample < TestYaoResource

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
    assert_equal("2e589cbc-738f-11e9-a9b2-bc764e200515", sample.id)
    assert_equal(sample.metadata, {
      "name1" => "value1",
      "name2" => "value2"
    })
    assert_equal("instance", sample.meter)
    assert_equal("openstack", sample.source)
    assert_equal("gauge", sample.type)
    assert_equal("instance", sample.unit)
    assert_equal(1.0, sample.volume)
    assert_equal("bd9431c1-8d69-4ad3-803a-8d4a6b89fd36", sample.resource_id)
    assert_equal("efd87807-12d2-4b38-9c70-5f5c2ac427ff", sample.user_id)
    assert_equal(Time.parse("2015-01-01T12:00:00"), sample.recorded_at)
    assert_equal(Time.parse("2015-01-01T12:00:00"), sample.timestamp)
  end

  def test_resource
    # https://docs.openstack.org/ceilometer/pike/webapi/v2.html
    stub = stub_request(:get, "https://example.com:12345/v2/resources/00000000-0000-0000-0000-000000000000")
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
    assert_equal("00000000-0000-0000-0000-000000000000", sample.resource.id)

    assert_requested(stub)
  end
end
