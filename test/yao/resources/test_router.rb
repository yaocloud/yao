class TestRouter < TestYaoResource

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

    assert_equal("915a14a6-867b-4af7-83d1-70efceb146f9", router.id)

    # friendly_attributes
    assert_equal("0bd18306d801447bb457a46252d82d13", router.tenant_id)
    assert_equal("0bd18306d801447bb457a46252d82d13", router.project_id)
    assert_equal("router2", router.name)
    assert_equal("", router.description)
    assert_equal(true, router.admin_state_up)
    assert_equal("ACTIVE", router.status)
    assert_equal({
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
    }, router.external_gateway_info)

    assert_equal([
      {
        "destination" => "179.24.1.0/24",
        "nexthop" => "172.24.3.99"
      }
    ], router.routes)

    assert_equal(false, router.distributed)
    assert_equal(false, router.ha)
    assert_equal([], router.availability_zone_hints)
    assert_equal([ "nova" ], router.availability_zones)

    pend 'oops. These are invalid friendly_attributes'
    assert_equal( '', router.network_id)
    assert_equal('', router.enable_snat)
    assert_equal(router.external_fixed_ips '')
    assert_equal(router.destination '')
    assert_equal(router.nexthop '')
  end

  def test_iterfaces
    stub = stub_request(:get, "https://example.com:12345/ports?device_id=00000000-0000-0000-0000-000000000000")
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
    assert_equal("00000000-0000-0000-0000-000000000000", port.id)

    assert_requested(stub)
  end

  def test_tenant

    stub = stub_request(:get, "https://example.com:12345/tenants/0123456789abcdef0123456789abcdef")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "tenant": {
            "id": "0123456789abcdef0123456789abcdef"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    router = Yao::Router.new('tenant_id' => '0123456789abcdef0123456789abcdef')
    assert_instance_of(Yao::Tenant, router.tenant)
    assert_equal('0123456789abcdef0123456789abcdef', router.tenant.id)

    assert_requested(stub)
  end
end
