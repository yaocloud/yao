class TestLoadBalancer < TestYaoResource
  def test_loadbalancer
    # https://docs.openstack.org/api-ref/load-balancer/v2/?expanded=list-amphora-detail,show-amphora-statistics-detail#list-amphora
    params = {
        "id": "6bd55cd3-802e-447e-a518-1e74e23bb106",
        "load_balancer_id": "09eedfc6-2c55-41a8-a75c-2cd4e95212ca",
        "compute_id": "f0f79f90-733d-417a-8d70-cc6be62cd54d",
        "lb_network_ip": "192.168.1.2",
        "vrrp_ip": "192.168.1.5",
        "ha_ip": "192.168.1.10",
        "vrrp_port_id": "ab2a8add-76a9-44bb-89f8-88430193cc83",
        "ha_port_id": "19561fd3-5da5-46cc-bdd3-99bbdf7246e6",
        "cert_expiration": "2019-09-19 00:34:51",
        "cert_busy": 0,
        "role": "MASTER",
        "status": "ALLOCATED",
        "vrrp_interface": "eth1",
        "vrrp_id": 1,
        "vrrp_priority": 100,
        "cached_zone": "zone1",
        "created_at": "2017-05-10T18:14:44",
        "updated_at": "2017-05-10T23:08:12",
        "image_id": "c1c2ad6f-1c1e-4744-8d1a-d0ef36289e74",
        "compute_flavor": "5446a14a-abec-4455-bc0e-a34e5ff001a3"
    }

    amphora = Yao::Resources::Amphora.new(params)
    assert_equal("6bd55cd3-802e-447e-a518-1e74e23bb106", amphora.id)
    assert_equal("09eedfc6-2c55-41a8-a75c-2cd4e95212ca", amphora.load_balancer_id)
    assert_equal("f0f79f90-733d-417a-8d70-cc6be62cd54d", amphora.compute_id)
    assert_equal("192.168.1.2", amphora.lb_network_ip)
    assert_equal("192.168.1.5", amphora.vrrp_ip)
    assert_equal("192.168.1.10", amphora.ha_ip)
    assert_equal("ab2a8add-76a9-44bb-89f8-88430193cc83", amphora.vrrp_port_id)
    assert_equal("19561fd3-5da5-46cc-bdd3-99bbdf7246e6", amphora.ha_port_id)
    assert_equal("MASTER", amphora.role)
    assert_equal("ALLOCATED", amphora.status)
    assert_equal("eth1", amphora.vrrp_interface)
    assert_equal(1, amphora.vrrp_id)
    assert_equal(100, amphora.vrrp_priority)
    assert_equal("zone1", amphora.cached_zone)
    assert_equal("c1c2ad6f-1c1e-4744-8d1a-d0ef36289e74", amphora.image_id)
    assert_equal("5446a14a-abec-4455-bc0e-a34e5ff001a3", amphora.compute_flavor)
  end
end
