class TestFloatingIP < Test::Unit::TestCase

  def setup
    Yao.default_client.pool["compute"] = Yao::Client.gen_client("https://example.com:12345")
  end

  def test_floating_ip
    params = {
      "router_id" => "d23abc8d-2991-4a55-ba98-2aaea84cc72f",
      "description" => "for test",
      "dns_domain" => "my-domain.org.",
      "dns_name" => "myfip",
      "created_at" => "2016-12-21T10:55:50Z",
      "updated_at" => "2016-12-21T10:55:53Z",
      "revision_number" => 1,
      "project_id" => "4969c491a3c74ee4af974e6d800c62de",
      "tenant_id" => "4969c491a3c74ee4af974e6d800c62de",
      "floating_network_id" => "376da547-b977-4cfe-9cba-275c80debf57",
      "fixed_ip_address" => "10.0.0.3",
      "floating_ip_address" => "172.24.4.228",
      "port_id" => "ce705c24-c1ef-408a-bda3-7bbd946164ab",
      "id" => "2f245a7b-796b-4f26-9cf9-9e82d248fda7",
      "status" => "ACTIVE",
      "port_details" => {
        "status" => "ACTIVE",
        "name" => "",
        "admin_state_up" => true,
        "network_id" => "02dd8479-ef26-4398-a102-d19d0a7b3a1f",
        "device_owner" => "compute:nova",
        "mac_address" => "fa:16:3e:b1:3b:30",
        "device_id" => "8e3941b4-a6e9-499f-a1ac-2a4662025cba"
      },
      "tags" => ["tag1,tag2"],
      "port_forwardings" => []
    }

    fip = Yao::Resources::FloatingIP.new(params)
    assert_equal(fip.router_id, "d23abc8d-2991-4a55-ba98-2aaea84cc72f")
    assert_equal(fip.description, "for test")
    assert_equal(fip.dns_domain, "my-domain.org.")
    assert_equal(fip.dns_name, "myfip")
    assert_equal(fip.created, Time.parse("2016-12-21T10:55:50Z"))
    assert_equal(fip.updated, Time.parse("2016-12-21T10:55:53Z"))
    assert_equal(fip.revision_number, 1)
    assert_equal(fip.project_id, "4969c491a3c74ee4af974e6d800c62de")
    assert_equal(fip.tenant_id, "4969c491a3c74ee4af974e6d800c62de")
    assert_equal(fip.floating_network_id, "376da547-b977-4cfe-9cba-275c80debf57")
    assert_equal(fip.fixed_ip_address, "10.0.0.3")
    assert_equal(fip.floating_ip_address, "172.24.4.228")
    assert_equal(fip.port_id, "ce705c24-c1ef-408a-bda3-7bbd946164ab")
    assert_equal(fip.id, "2f245a7b-796b-4f26-9cf9-9e82d248fda7")
    assert_equal(fip.status, "ACTIVE")
    assert_equal(fip.tags, ["tag1,tag2"])
    assert_equal(fip.port_details, {
        "status" => "ACTIVE",
        "name" => "",
        "admin_state_up" => true,
        "network_id" => "02dd8479-ef26-4398-a102-d19d0a7b3a1f",
        "device_owner" => "compute:nova",
        "mac_address" => "fa:16:3e:b1:3b:30",
        "device_id" => "8e3941b4-a6e9-499f-a1ac-2a4662025cba"
    })
    assert_equal(fip.port_forwardings, [])
  end

  def test_floating_ip_to_router

    stub_request(:get, "http://neutron-endpoint.example.com:9696/v2.0/routers/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "routers": [{
            "id": "0123456789abcdef0123456789abcdef"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    fip = Yao::FloatingIP.new("router_id" => "00000000-0000-0000-0000-000000000000")
    assert_instance_of(Yao::Router, fip.router)
  end

  def test_floating_to_tenant

    stub_request(:get, "http://endpoint.example.com:12345/v2.0/tenants/0123456789abcdef0123456789abcdef")
      .to_return(
         status: 200,
         body: <<-JSON,
        {
          "tenants": [{
            "id": "0123456789abcdef0123456789abcdef"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    fip = Yao::FloatingIP.new(
      "project_id" => "0123456789abcdef0123456789abcdef",
      "tenant_id"  => "0123456789abcdef0123456789abcdef",
    )

    assert_instance_of(Yao::Tenant, fip.tenant)
    assert_instance_of(Yao::Tenant, fip.project)
  end

  def test_floating_ip_to_port

    stub_request(:get, "http://neutron-endpoint.example.com:9696/v2.0/ports/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "ports": [{
            "id": "0123456789abcdef0123456789abcdef"
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    fip = Yao::FloatingIP.new("port_id" => "00000000-0000-0000-0000-000000000000")
    assert_instance_of(Yao::Port, fip.port)
  end
end
