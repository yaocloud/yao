class TestComputeServices < Test::Unit::TestCase
  def setup
    Yao.default_client.pool["compute"] = Yao::Client.gen_client("https://example.com:12345")
  end

  def test_compute_services

    # https://docs.openstack.org/api-ref/compute/?expanded=update-forced-down-detail,update-compute-service-detail,list-compute-services-detail#compute-services-os-services
    params = {
      "id" =>  1,
      "binary" =>  "nova-scheduler",
      "disabled_reason" =>  "test1",
      "host" =>  "host1",
      "state" =>  "up",
      "status" =>  "disabled",
      "updated_at" =>  "2012-10-29T13:42:02.000000",
      "forced_down" =>  false,
      "zone" =>  "internal"
    }
    compute_service = Yao::ComputeServices.new(params)

    assert_equal(compute_service.id, 1)
    assert_equal(compute_service.binary, "nova-scheduler")
    assert_equal(compute_service.disabled_reason, "test1")
    assert_equal(compute_service.host, "host1")
    assert_equal(compute_service.state, "up")
    assert_equal(compute_service.status, "disabled")
    assert_equal(compute_service.updated, Time.mktime(2012,10,29,13,42,2))
    assert_equal(compute_service.forced_down, false)
    assert_equal(compute_service.zone, "internal")
  end
end