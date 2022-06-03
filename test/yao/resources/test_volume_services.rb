class TestVolumeServices < TestYaoResource
  include RestfullyAccessibleStub

  def test_volume_services
    # https://docs.openstack.org/api-ref/block-storage/v3/index.html?expanded=list-all-cinder-services-detail#list-all-cinder-services
    params = JSON.parse(<<~JSON)
    {
        "status": "enabled",
        "binary": "cinder-scheduler",
        "zone": "nova",
        "state": "up",
        "updated_at": "2017-06-29T05:50:35.000000",
        "host": "devstack",
        "disabled_reason": null
    }
    JSON

    service = Yao::VolumeServices.new(params)
    assert_equal('enabled', service.status)
    assert_equal('cinder-scheduler', service.binary)
    assert_equal('nova', service.zone)
    assert_equal('up', service.state)
    assert_equal(Time.parse('2017-06-29T05:50:35.000000'), service.updated_at)
    assert_equal('devstack', service.host)
    assert_equal(nil, service.disabled_reason)
  end

  def test_enabled
    service = Yao::VolumeServices.new({'status' => 'enabled'})
    assert_equal(true, service.enabled?)
  end

  def test_disabled
    service = Yao::VolumeServices.new({'status' => 'enabled'})
    assert_equal(false, service.disabled?)
  end

  def stub_enable_request
    body = {
      "host" => "test-host",
      "binary" => "test-binary",
    }
    response = { "disabled" => false }
    stub_put_request('https://example.com:12345/os-services/enable', body, response)
  end

  def test_enable
    stub = stub_enable_request
    service = Yao::VolumeServices.new({
      "host" => "test-host",
      "binary" => "test-binary",
    })
    response = service.enable
    assert_equal(false, response['disabled'])
    assert_requested(stub)
  end

  def test_self_enable
    stub = stub_enable_request
    response = Yao::VolumeServices.enable('test-host', 'test-binary')
    assert_equal(false, response['disabled'])
    assert_requested(stub)
  end

  def stub_disable_request(reason = nil)
    body = {
      "host" => "test-host",
      "binary" => "test-binary",
    }
    response = { "disabled" => true }
    if reason
      body["disabled_reason"] = reason
      response["disabled_reason"] = reason
      stub_put_request('https://example.com:12345/os-services/disable-log-reason', body, response)
    else
      stub_put_request('https://example.com:12345/os-services/disable', body, response)
    end
  end

  def test_disable
    stub = stub_disable_request
    service = Yao::VolumeServices.new({
      "host" => "test-host",
      "binary" => "test-binary",
    })
    response = service.disable
    assert_equal(true, response['disabled'])
    assert_requested(stub)
  end

  def test_disable_reason
    stub = stub_disable_request('test-reason')
    service = Yao::VolumeServices.new({
      "host" => "test-host",
      "binary" => "test-binary",
    })
    response = service.disable('test-reason')
    assert_equal(true, response['disabled'])
    assert_equal('test-reason', response['disabled_reason'])
    assert_requested(stub)
  end

  def test_self_disable
    stub = stub_disable_request
    response = Yao::VolumeServices.disable('test-host', 'test-binary')
    assert_equal(true, response['disabled'])
    assert_requested(stub)
  end

  def test_self_disable_reason
    stub = stub_disable_request('test-reason')
    response = Yao::VolumeServices.disable('test-host', 'test-binary', 'test-reason')
    assert_equal(true, response['disabled'])
    assert_requested(stub)
  end
end
