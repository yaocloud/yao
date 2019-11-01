class TestOldSample < TestYaoResource

  def test_old_sample

    # https://docs.openstack.org/ceilometer/pike/webapi/v2.html#Sample
    params = {
      "counter_name" => "instance",
      "counter_type" => "gauge",
      "counter_unit" => "instance",
      "counter_volume" => 1.0,
      "message_id" => "5460acce-4fd6-480d-ab18-9735ec7b1996",
      "project_id" => "35b17138-b364-4e6a-a131-8f3099c5be68",
      "recorded_at" => "2015-01-01T12:00:00",
      "resource_id" => "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
      "resource_metadata" => {
        "name1" => "value1",
        "name2" => "value2"
      },
      "source" => "openstack",
      "timestamp" => "2015-01-01T12:00:00",
      "user_id" => "efd87807-12d2-4b38-9c70-5f5c2ac427ff"
    }

    sample = Yao::Resources::OldSample.new(params)

    assert_equal("5460acce-4fd6-480d-ab18-9735ec7b1996", sample.id)
    assert_equal("5460acce-4fd6-480d-ab18-9735ec7b1996", sample.message_id)

    assert_equal("instance", sample.counter_name)
    assert_equal("gauge", sample.counter_type)
    assert_equal("instance", sample.counter_unit)
    assert_equal(1.0, sample.counter_volume)
    assert_equal("bd9431c1-8d69-4ad3-803a-8d4a6b89fd36", sample.resource_id)
    assert_equal(Time.parse("2015-01-01T12:00:00"), sample.timestamp)
    assert_equal({
      "name1" => "value1",
      "name2" => "value2"
    }, sample.resource_metadata)
    assert_equal("efd87807-12d2-4b38-9c70-5f5c2ac427ff", sample.user_id)
    assert_equal("openstack", sample.source)
    assert_equal(Time.parse("2015-01-01T12:00:00"), sample.recorded_at)
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

    sample = Yao::Resources::OldSample.new( 'resource_id' => '00000000-0000-0000-0000-000000000000' )

    assert_instance_of(Yao::Resources::Resource, sample.resource)
    assert_equal("00000000-0000-0000-0000-000000000000", sample.resource.id)

    assert_requested(stub)
  end

  def test_user

    stub = stub_request(:get, "https://example.com:12345/users/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "user": {
            "id": "00000000-0000-0000-0000-000000000000"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    meter  = Yao::OldSample.new( "user_id" => "00000000-0000-0000-0000-000000000000" )
    assert_instance_of(Yao::User, meter.user)
    assert_equal("00000000-0000-0000-0000-000000000000", meter.user.id)

    assert_requested(stub)
  end

  def test_list
    stub = stub_request(:get, "https://example.com:12345/v2/meters/?q.field=timestamp&q.op=gt&q.value=2015-01-01T00:00:00%2B00:00")
               .to_return(
                   status: 200,
                   body: <<-JSON,
                   [
                     {
                       "counter_name": "instance",
                       "counter_type": "gauge",
                       "counter_unit": "instance",
                       "counter_volume": 1.0,
                       "message_id": "5460acce-4fd6-480d-ab18-9735ec7b1996",
                       "project_id": "35b17138-b364-4e6a-a131-8f3099c5be68",
                       "recorded_at": "2015-01-01T12:00:00",
                       "resource_id": "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
                       "resource_metadata": {
                           "name1": "value1",
                           "name2": "value2"
                       },
                       "source": "openstack",
                       "timestamp": "2015-01-01T12:00:00",
                       "user_id": "efd87807-12d2-4b38-9c70-5f5c2ac427ff"
                     },
                     {
                       "counter_name": "instance",
                       "counter_type": "gauge",
                       "counter_unit": "instance",
                       "counter_volume": 1.0,
                       "message_id": "5460acce-4fd6-480d-ab18-9735ec7b1996",
                       "project_id": "35b17138-b364-4e6a-a131-8f3099c5be68",
                       "recorded_at": "2015-01-01T12:00:00",
                       "resource_id": "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
                       "resource_metadata": {
                           "name1": "value1",
                           "name2": "value2"
                       },
                       "source": "openstack",
                       "timestamp": "2015-01-01T12:00:00",
                       "user_id": "efd87807-12d2-4b38-9c70-5f5c2ac427ff"
                     }
                   ]
                   JSON
                   headers: {'Content-Type' => 'application/json'}
               )

    oldsamples  = Yao::OldSample.list("", {'q.field': 'timestamp', 'q.op': 'gt', 'q.value': "2015-01-01T00:00:00+00:00"})
    assert_instance_of(Array, oldsamples)
    assert_requested(stub)
  end
end
