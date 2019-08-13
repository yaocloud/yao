class TestMeter < Test::Unit::TestCase

  def setup
    Yao.default_client.pool["metering"] = Yao::Client.gen_client("https://example.com:12345")
  end

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
    assert_equal(meter.meter_id, "YmQ5NDMxYzEtOGQ2OS00YWQzLTgwM2EtOGQ0YTZiODlmZDM2K2luc3RhbmNl")
    assert_equal(meter.meter_id, meter.id)
    assert_equal(meter.name, "instance")
    assert_equal(meter.project_id, "35b17138-b364-4e6a-a131-8f3099c5be68")
    assert_equal(meter.resource_id, "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36")
    assert_equal(meter.source, "openstack")
    assert_equal(meter.type, "gauge")
    assert_equal(meter.unit, "instance")
    assert_equal(meter.user_id, "efd87807-12d2-4b38-9c70-5f5c2ac427ff")
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

    params = {
      "resource_id" => "00000000-0000-0000-0000-000000000000",
    }

    meter    = Yao::Meter.new(params)
    resource = meter.resource
    assert { resource.instance_of?(Yao::Resource) }
    assert_equal(resource.resource_id, "00000000-0000-0000-0000-000000000000")
  end
end
