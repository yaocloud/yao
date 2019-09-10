class TestLoadBalancerListener < TestYaoResource
  def test_loadbalancer_listener
    params = {
      "description" => "A great TLS listener",
      "admin_state_up" => true,
      "protocol" => "TERMINATED_HTTPS",
      "protocol_port" => 443,
      "provisioning_status" => "ACTIVE",
      "default_tls_container_ref" => "http://198.51.100.10:9311/v1/containers/a570068c-d295-4780-91d4-3046a325db51",
      "insert_headers" => {
          "X-Forwarded-Port" => "true",
          "X-Forwarded-For" => "true"
      },
      "created_at" => "2017-02-28T00:42:44",
      "updated_at" => "2017-02-28T00:44:30",
      "operating_status" => "ONLINE",
      "sni_container_refs" => [
          "http://198.51.100.10:9311/v1/containers/a570068c-d295-4780-91d4-3046a325db51",
          "http://198.51.100.10:9311/v1/containers/aaebb31e-7761-4826-8cb4-2b829caca3ee"
      ],
      "l7policies" => [
          {
              "id" => "5e618272-339d-4a80-8d14-dbc093091bb1"
          }
      ],
      "name" => "great_tls_listener"
    }

    listener = Yao::Resources::LoadBalancerListener.new(params)
    assert_equal("A great TLS listener", listener.description)
    assert_equal(true, listener.admin_state_up)
    assert_equal("TERMINATED_HTTPS", listener.protocol)
    assert_equal(443, listener.protocol_port)
    assert_equal("ACTIVE", listener.provisioning_status)
    assert_equal("http://198.51.100.10:9311/v1/containers/a570068c-d295-4780-91d4-3046a325db51", listener.default_tls_container_ref)
    assert_equal(listener.insert_headers, {
      "X-Forwarded-Port" => "true",
      "X-Forwarded-For" => "true"
    })
    assert_equal(Time.parse("2017-02-28T00:42:44"), listener.created)
    assert_equal(Time.parse("2017-02-28T00:44:30"), listener.updated)
    assert_equal("ONLINE", listener.operating_status)
    assert_equal(listener.sni_container_refs, [
      "http://198.51.100.10:9311/v1/containers/a570068c-d295-4780-91d4-3046a325db51",
      "http://198.51.100.10:9311/v1/containers/aaebb31e-7761-4826-8cb4-2b829caca3ee"
    ])
    assert_equal(listener.l7policies, [
        {
            "id" => "5e618272-339d-4a80-8d14-dbc093091bb1"
        }
    ])
    assert_equal("great_tls_listener", listener.name)
  end
end
