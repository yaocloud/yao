class TestVolumeServices < TestYaoResource
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
end
