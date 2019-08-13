class TestMeter < Test::Unit::TestCase

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
end
