class TestComputeServices < TestYaoResource
  include RestfullyAccessibleStub

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

    assert_equal(1, compute_service.id)
    assert_equal("nova-scheduler", compute_service.binary)
    assert_equal("test1", compute_service.disabled_reason)
    assert_equal("host1", compute_service.host)
    assert_equal("up", compute_service.state)
    assert_equal("disabled", compute_service.status)
    assert_equal(Time.mktime(2012,10,29,13,42,2), compute_service.updated)
    assert_equal(false, compute_service.forced_down)
    assert_equal("internal", compute_service.zone)
  end

  def test_enabled?
    compute_service = Yao::ComputeServices.new( 'status' => 'enabled' )
    assert_true  compute_service.enabled?
    assert_false compute_service.disabled?
  end

  def test_disabled?
    compute_service = Yao::ComputeServices.new( 'status' => 'disabled' )
    assert_false compute_service.enabled?
    assert_true  compute_service.disabled?
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

    assert_equal("host1", compute_service.host)
    assert_equal("nova-compute", compute_service.binary)
    assert_equal("enabled", compute_service.status)

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

    assert_equal("host1", compute_service.host)
    assert_equal("nova-compute", compute_service.binary)
    assert_equal("disabled", compute_service.status)

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

    assert_equal("host1", compute_service.host)
    assert_equal("nova-compute", compute_service.binary)
    assert_equal("disabled", compute_service.status)
    assert_equal("test2", compute_service.disabled_reason)

    assert_requested stub
  end

  def test_delete
    stub = stub_delete_request("https://example.com:12345/os-services/test-id")
    compute_service = Yao::ComputeServices.new({"id" => "test-id"})
    assert_equal({}, compute_service.delete)
    assert_requested(stub)
  end
end
