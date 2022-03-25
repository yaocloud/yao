class TestMeter < TestYaoResource

  def test_meter
    # https://docs.openstack.org/ceilometer/pike/webapi/v2.html
    params = {
      "meter_id" => "YmQ5NDMxYzEtOGQ2OS00YWQzLTgwM2EtOGQ0YTZiODlmZDM2K2luc3RhbmNl",
      "name" => "instance",
      "project_id" => "35b17138-b364-4e6a-a131-8f3099c5be68",
      "resource_id" => "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
      "source" => "openstack",
      "type" => "gauge",
      "unit" => "instance",
      "user_id" => "efd87807-12d2-4b38-9c70-5f5c2ac427ff"
    }

    meter = Yao::Meter.new(params)

    # friendly_attributes
    assert_equal("YmQ5NDMxYzEtOGQ2OS00YWQzLTgwM2EtOGQ0YTZiODlmZDM2K2luc3RhbmNl", meter.meter_id)
    assert_equal(meter.id, meter.meter_id)
    assert_equal("instance", meter.name)
    assert_equal("35b17138-b364-4e6a-a131-8f3099c5be68", meter.project_id)
    assert_equal("bd9431c1-8d69-4ad3-803a-8d4a6b89fd36", meter.resource_id)
    assert_equal("openstack", meter.source)
    assert_equal("gauge", meter.type)
    assert_equal("instance", meter.unit)
    assert_equal("efd87807-12d2-4b38-9c70-5f5c2ac427ff", meter.user_id)
  end

  def test_list
    stub = stub_request(:get, "https://example.com:12345/v2/meters")
               .to_return(
                   status: 200,
                   # https://docs.openstack.org/ceilometer/pike/webapi/v2.html#meters
                   body: <<-JSON,
                   [
                     {
                       "meter_id": "YmQ5NDMxYzEtOGQ2OS00YWQzLTgwM2EtOGQ0YTZiODlmZDM2K2luc3RhbmNl",
                       "name": "instance",
                       "project_id": "35b17138-b364-4e6a-a131-8f3099c5be68",
                       "resource_id": "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
                       "source": "openstack",
                       "type": "gauge",
                       "unit": "instance",
                       "user_id": "efd87807-12d2-4b38-9c70-5f5c2ac427ff"
                     },
                     {
                       "meter_id": "YmQ5NDMxYzEtOGQ2OS00YWQzLTgwM2EtOGQ0YTZiODlmZDM2K2luc3RhbmNl",
                       "name": "instance",
                       "project_id": "35b17138-b364-4e6a-a131-8f3099c5be68",
                       "resource_id": "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
                       "source": "openstack",
                       "type": "gauge",
                       "unit": "instance",
                       "user_id": "efd87807-12d2-4b38-9c70-5f5c2ac427ff"
                     }
                   ]
                   JSON
                   headers: {'Content-Type' => 'application/json'}
               )
    meters = Yao::Meter.list
    assert_instance_of(Array, meters)
    assert_requested(stub)
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

    params = {
      "resource_id" => "00000000-0000-0000-0000-000000000000",
    }

    meter    = Yao::Meter.new(params)
    assert_instance_of(Yao::Resource, meter.resource)
    assert_equal("00000000-0000-0000-0000-000000000000", meter.resource.resource_id)
    assert_equal("00000000-0000-0000-0000-000000000000", meter.resource.id)

    assert_requested(stub)
  end

  def test_project
    stub = stub_request(:get, "https://example.com:12345/projects/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "project": {
            "id": "00000000-0000-0000-0000-000000000000"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    params = {
      "project_id" => "00000000-0000-0000-0000-000000000000",
    }

    meter  = Yao::Meter.new(params)
    assert_instance_of(Yao::Project, meter.project)
    assert_equal("00000000-0000-0000-0000-000000000000", meter.project.id)

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

    params = {
      "user_id" => "00000000-0000-0000-0000-000000000000",
    }

    meter  = Yao::Meter.new(params)
    assert_instance_of(Yao::User, meter.user)
    assert_equal("00000000-0000-0000-0000-000000000000", meter.user.id)

    assert_requested(stub)
  end
end
