class TestRouter < TestYaoResouce

  def test_router

    # https://docs.openstack.org/api-ref/network/v2/?expanded=list-subnets-detail,list-routers-detail#list-routers
    params = {
      "admin_state_up" => true,
      "availability_zone_hints" => [],
      "availability_zones" => [
        "nova"
      ],
      "created_at" => "2018-03-19T19:17:04Z",
      "description" => "",
      "distributed" => false,
      "external_gateway_info" => {
        "enable_snat" => true,
        "external_fixed_ips" => [
          {
            "ip_address" => "172.24.4.3",
            "subnet_id" => "b930d7f6-ceb7-40a0-8b81-a425dd994ccf"
          },
          {
            "ip_address" => "2001:db8::c",
            "subnet_id" => "0c56df5d-ace5-46c8-8f4c-45fa4e334d18"
          }
        ],
        "network_id" => "ae34051f-aa6c-4c75-abf5-50dc9ac99ef3"
      },
      "flavor_id" => "f7b14d9a-b0dc-4fbe-bb14-a0f4970a69e0",
      "ha" => false,
      "id" => "915a14a6-867b-4af7-83d1-70efceb146f9",
      "name" => "router2",
      "revision_number" => 1,
      "routes" => [
        {
          "destination" => "179.24.1.0/24",
          "nexthop" => "172.24.3.99"
        }
      ],
      "status" => "ACTIVE",
      "updated_at" => "2018-03-19T19:17:22Z",
      "project_id" => "0bd18306d801447bb457a46252d82d13",
      "tenant_id" => "0bd18306d801447bb457a46252d82d13",
      "service_type_id" => nil,
      "tags" => ["tag1,tag2"],
      "conntrack_helpers" => [
        {
          "protocol" => "udp",
          "helper" => "tftp",
          "port" => 69
        },
        {
          "protocol" => "tcp",
          "helper" => "ftp",
          "port" => 21
        }
      ]
    }

    router = Yao::Router.new(params)

    assert_equal(router.id, "915a14a6-867b-4af7-83d1-70efceb146f9")

    # friendly_attributes
    assert_equal(router.tenant_id, "0bd18306d801447bb457a46252d82d13")
    assert_equal(router.project_id, "0bd18306d801447bb457a46252d82d13")
    assert_equal(router.name, "router2")
    assert_equal(router.description, "")
    assert_equal(router.admin_state_up, true)
    assert_equal(router.status, "ACTIVE")
    assert_equal(router.external_gateway_info, {
      "enable_snat" => true,
      "external_fixed_ips" => [
        {
          "ip_address" => "172.24.4.3",
          "subnet_id" => "b930d7f6-ceb7-40a0-8b81-a425dd994ccf"
        },
        {
          "ip_address" => "2001:db8::c",
          "subnet_id" => "0c56df5d-ace5-46c8-8f4c-45fa4e334d18"
        }
      ],
      "network_id" => "ae34051f-aa6c-4c75-abf5-50dc9ac99ef3"
    })

    assert_equal(router.routes, [
      {
        "destination" => "179.24.1.0/24",
        "nexthop" => "172.24.3.99"
      }
    ])

    assert_equal(router.distributed, false)
    assert_equal(router.ha, false)
    assert_equal(router.availability_zone_hints, [])
    assert_equal(router.availability_zones, [ "nova" ])

    pend 'oops. These are invalid friendly_attributes'
    assert_equal(router.network_id,  '')
    assert_equal(router.enable_snat, '')
    assert_equal(router.external_fixed_ips '')
    assert_equal(router.destination '')
    assert_equal(router.nexthop '')
  end

  def test_iterfaces
    stub_request(:get, "https://example.com:12345/ports?device_id=00000000-0000-0000-0000-000000000000")
    .to_return(
        status: 200,
        body: <<-JSON,
        {
          "ports": [{
            "id": "00000000-0000-0000-0000-000000000000"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    params = {
      "id" => "00000000-0000-0000-0000-000000000000",
    }

    router = Yao::Router.new(params)
    port   = router.interfaces.first
    assert_instance_of(Yao::Port, port)
    assert_equal(port.id, "00000000-0000-0000-0000-000000000000")
  end
end
