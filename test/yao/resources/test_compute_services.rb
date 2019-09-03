class TestComputeServices < TestYaoResouce

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

  def test_enable
    stub = stub_request(:put, "https://example.com:12345/os-services/enable").
      with(
        body: <<~JSON.chomp
        {"host":"host1","binary":"nova-compute"}
        JSON
      ).to_return(
        status: 200,
        body: <<-JSON,
        {
            "service": {
                "binary": "nova-compute",
                "host": "host1",
                "status": "enabled"
            }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    compute_service = Yao::ComputeServices.enable('host1', 'nova-compute')

    assert_equal(compute_service.host, "host1")
    assert_equal(compute_service.binary, "nova-compute")
    assert_equal(compute_service.status, "enabled")

    assert_requested stub
  end

  def test_disable
    stub = stub_request(:put, "https://example.com:12345/os-services/disable").
      with(
        body: <<~JSON.chomp
        {"host":"host1","binary":"nova-compute"}
        JSON
      ).to_return(
        status: 200,
        body: <<-JSON,
        {
            "service": {
                "binary": "nova-compute",
                "host": "host1",
                "status": "disabled"
           }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
    )

    compute_service = Yao::ComputeServices.disable('host1', 'nova-compute')

    assert_equal(compute_service.host, "host1")
    assert_equal(compute_service.binary, "nova-compute")
    assert_equal(compute_service.status, "disabled")

    assert_requested stub
  end

  def test_disable_with_reason
    stub = stub_request(:put, "https://example.com:12345/os-services/disable-log-reason").
      with(
        body: <<~JSON.chomp
        {"host":"host1","binary":"nova-compute","disabled_reason":"test2"}
        JSON
      ).to_return(
        status: 200,
        body: <<-JSON,
        {
            "service": {
                "binary": "nova-compute",
                "disabled_reason": "test2",
                "host": "host1",
                "status": "disabled"
            }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
    )

    compute_service = Yao::ComputeServices.disable('host1', 'nova-compute', 'test2')

    assert_equal(compute_service.host, "host1")
    assert_equal(compute_service.binary, "nova-compute")
    assert_equal(compute_service.status, "disabled")
    assert_equal(compute_service.disabled_reason, "test2")

    assert_requested stub
  end
end
