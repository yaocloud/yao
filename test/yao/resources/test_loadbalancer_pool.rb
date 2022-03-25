class TestLoadBalancerPool < TestYaoResource
  def test_loadbalancer_pool
    params = {
      "lb_algorithm" => "ROUND_ROBIN",
      "protocol" => "HTTP",
      "description" => "My round robin pool",
      "admin_state_up" => true,
      "created_at" => "2017-04-13T18:14:44",
      "provisioning_status" => "ACTIVE",
      "updated_at" => "2017-04-13T23:08:12",
      "session_persistence" => {
        "cookie_name" => nil,
        "type" => "SOURCE_IP"
      },
      "operating_status" => "ONLINE",
      "name" => "round_robin_pool",
      "members" => [
        {"id" => "957a1ace-1bd2-449b-8455-820b6e4b63f3"},
      ],
      "listeners" => [
        {"id" => "023f2e34-7806-443b-bfae-16c324569a3d"}
      ],
      "healthmonitor_id" => "8ed3c5ac-6efa-420c-bedb-99ba14e58db5",
    }

    pool = Yao::Resources::LoadBalancerPool.new(params)
    assert_equal("ROUND_ROBIN", pool.lb_algorithm)
    assert_equal("HTTP", pool.protocol)
    assert_equal("My round robin pool", pool.description)
    assert_equal(true, pool.admin_state_up)
    assert_equal(Time.parse("2017-04-13T18:14:44"), pool.created)
    assert_equal("ACTIVE", pool.provisioning_status)
    assert_equal(Time.parse("2017-04-13T23:08:12"), pool.updated)
    assert_equal({
        "cookie_name" => nil,
        "type" => "SOURCE_IP"
    }, pool.session_persistence)
    assert_equal("ONLINE", pool.operating_status)
    assert_equal("round_robin_pool", pool.name)

    # https://docs.openstack.org/api-ref/load-balancer/v2/?expanded=show-member-details-detail#show-member-details
    stub = stub_request(:get, "http://endpoint.example.com:9876/v2.0/lbaas/pools//members/957a1ace-1bd2-449b-8455-820b6e4b63f3")
          .to_return(
            status: 200,
            body: <<-JSON,
            {
              "member": {
                "monitor_port": 8080,
                "project_id": "e3cd678b11784734bc366148aa37580e",
                "name": "web-server-1",
                "weight": 20,
                "backup": false,
                "admin_state_up": true,
                "subnet_id": "bbb35f84-35cc-4b2f-84c2-a6a29bba68aa",
                "created_at": "2017-05-11T17:21:34",
                "provisioning_status": "ACTIVE",
                "monitor_address": null,
                "updated_at": "2017-05-11T17:21:37",
                "address": "192.0.2.16",
                "protocol_port": 80,
                "id": "957a1ace-1bd2-449b-8455-820b6e4b63f3",
                "operating_status": "NO_MONITOR",
                "tags": ["test_tag"]
              }
            }
            JSON
            headers: {'Content-Type' => 'application/json'}
          )

    assert_instance_of(Yao::LoadBalancerPoolMember, pool.members.first)
    assert_equal("957a1ace-1bd2-449b-8455-820b6e4b63f3", pool.members.first.id)
    assert_equal("web-server-1", pool.members.first.name)
    assert_requested(stub)

    # https://docs.openstack.org/api-ref/load-balancer/v2/?expanded=show-member-details-detail,show-listener-details-detail,show-pool-details-detail#show-listener-details
    stub = stub_request(:get, "http://endpoint.example.com:9876/v2.0/lbaas/listeners/023f2e34-7806-443b-bfae-16c324569a3d")
          .to_return(
            status: 200,
            body: <<-JSON,
            {
              "listener": {
                "description": "A great TLS listener",
                "admin_state_up": true,
                "project_id": "e3cd678b11784734bc366148aa37580e",
                "protocol": "TERMINATED_HTTPS",
                "protocol_port": 443,
                "provisioning_status": "ACTIVE",
                "default_tls_container_ref": "http://198.51.100.10:9311/v1/containers/a570068c-d295-4780-91d4-3046a325db51",
                "loadbalancers": [
                  {
                    "id": "607226db-27ef-4d41-ae89-f2a800e9c2db"
                  }
                ],
                "insert_headers": {
                  "X-Forwarded-Port": "true",
                  "X-Forwarded-For": "true"
                },
                "created_at": "2017-02-28T00:42:44",
                "updated_at": "2017-02-28T00:44:30",
                "id": "023f2e34-7806-443b-bfae-16c324569a3d",
                "operating_status": "ONLINE",
                "default_pool_id": "ddb2b28f-89e9-45d3-a329-a359c3e39e4a",
                "sni_container_refs": [
                  "http://198.51.100.10:9311/v1/containers/a570068c-d295-4780-91d4-3046a325db51",
                  "http://198.51.100.10:9311/v1/containers/aaebb31e-7761-4826-8cb4-2b829caca3ee"
                ],
                "l7policies": [
                  {
                    "id": "5e618272-339d-4a80-8d14-dbc093091bb1"
                  }
                ],
                "name": "great_tls_listener",
                "timeout_client_data": 50000,
                "timeout_member_connect": 5000,
                "timeout_member_data": 50000,
                "timeout_tcp_inspect": 0,
                "tags": ["test_tag"],
                "client_ca_tls_container_ref": "http://198.51.100.10:9311/v1/containers/35649991-49f3-4625-81ce-2465fe8932e5",
                "client_authentication": "MANDATORY",
                "client_crl_container_ref": "http://198.51.100.10:9311/v1/containers/e222b065-b93b-4e2a-9a02-804b7a118c3c",
                "allowed_cidrs": [
                  "192.0.2.0/24",
                  "198.51.100.0/24"
                ],
                "tls_ciphers": "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256",
                "tls_versions": ["TLSv1.2", "TLSv1.3"],
                "alpn_protocols": ["http/1.1", "http/1.0"]
              }
            }
            JSON
            headers: {'Content-Type' => 'application/json'}
          )
    assert_instance_of(Yao::LoadBalancerListener, pool.listeners.first)
    assert_equal("023f2e34-7806-443b-bfae-16c324569a3d", pool.listeners.first.id)
    assert_equal("great_tls_listener", pool.listeners.first.name)
    assert_requested(stub)

    # https://docs.openstack.org/api-ref/load-balancer/v2/?expanded=show-member-details-detail,show-listener-details-detail,show-pool-details-detail,show-health-monitor-details-detail#show-health-monitor-details
    stub = stub_request(:get, "http://endpoint.example.com:9876/v2.0/lbaas/healthmonitors/8ed3c5ac-6efa-420c-bedb-99ba14e58db5")
          .to_return(
            status: 200,
            body: <<-JSON,
            {
              "healthmonitor": {
                "project_id": "e3cd678b11784734bc366148aa37580e",
                "name": "super-pool-health-monitor",
                "admin_state_up": true,
                "pools": [
                  {
                    "id": "4029d267-3983-4224-a3d0-afb3fe16a2cd"
                  }
                ],
                "created_at": "2017-05-11T23:53:47",
                "provisioning_status": "ACTIVE",
                "updated_at": "2017-05-11T23:53:47",
                "delay": 10,
                "expected_codes": "200",
                "max_retries": 1,
                "http_method": "GET",
                "timeout": 5,
                "max_retries_down": 3,
                "url_path": "/",
                "type": "HTTP",
                "id": "8ed3c5ac-6efa-420c-bedb-99ba14e58db5",
                "operating_status": "ONLINE",
                "tags": ["test_tag"],
                "http_version": 1.0,
                "domain_name": null
              }
            }
            JSON
            headers: {'Content-Type' => 'application/json'}
          )
    assert_instance_of(Yao::LoadBalancerHealthMonitor, pool.healthmonitor)
    assert_equal("8ed3c5ac-6efa-420c-bedb-99ba14e58db5", pool.healthmonitor.id)
    assert_equal("super-pool-health-monitor", pool.healthmonitor.name)
    assert_requested(stub)
  end
end
