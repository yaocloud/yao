class TestFloatingIP < TestYaoResource

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
    assert_equal("d23abc8d-2991-4a55-ba98-2aaea84cc72f", fip.router_id)
    assert_equal("for test", fip.description)
    assert_equal("my-domain.org.", fip.dns_domain)
    assert_equal("myfip", fip.dns_name)
    assert_equal(Time.parse("2016-12-21T10:55:50Z"), fip.created)
    assert_equal(Time.parse("2016-12-21T10:55:53Z"), fip.updated)
    assert_equal(1, fip.revision_number)
    assert_equal("4969c491a3c74ee4af974e6d800c62de", fip.project_id)
    assert_equal("4969c491a3c74ee4af974e6d800c62de", fip.tenant_id)
    assert_equal("376da547-b977-4cfe-9cba-275c80debf57", fip.floating_network_id)
    assert_equal("10.0.0.3", fip.fixed_ip_address)
    assert_equal("172.24.4.228", fip.floating_ip_address)
    assert_equal("ce705c24-c1ef-408a-bda3-7bbd946164ab", fip.port_id)
    assert_equal("2f245a7b-796b-4f26-9cf9-9e82d248fda7", fip.id)
    assert_equal("ACTIVE", fip.status)
    assert_equal(["tag1,tag2"], fip.tags)
    assert_equal({
        "status" => "ACTIVE",
        "name" => "",
        "admin_state_up" => true,
        "network_id" => "02dd8479-ef26-4398-a102-d19d0a7b3a1f",
        "device_owner" => "compute:nova",
        "mac_address" => "fa:16:3e:b1:3b:30",
        "device_id" => "8e3941b4-a6e9-499f-a1ac-2a4662025cba"
    },fip.port_details)
    assert_equal([], fip.port_forwardings)
  end

  def test_floating_ip_to_router

    stub = stub_request(:get, "https://example.com:12345/routers/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "router": {
            "id": "00000000-0000-0000-0000-000000000000"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    fip = Yao::FloatingIP.new("router_id" => "00000000-0000-0000-0000-000000000000")

    assert_instance_of(Yao::Router, fip.router)
    assert_equal("00000000-0000-0000-0000-000000000000", fip.router.id)

    assert_requested(stub)
  end

  def test_project

    stub = stub_request(:get, "https://example.com:12345/projects/0123456789abcdef0123456789abcdef")
      .to_return(
         status: 200,
         body: <<-JSON,
        {
          "project": {
            "id": "0123456789abcdef0123456789abcdef"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    fip = Yao::FloatingIP.new(
      "project_id" => "0123456789abcdef0123456789abcdef",
      "tenant_id"  => "0123456789abcdef0123456789abcdef",
    )

    assert_instance_of(Yao::Project, fip.tenant)
    assert_instance_of(Yao::Project, fip.project)
    assert_equal('0123456789abcdef0123456789abcdef', fip.tenant.id)

    assert_requested(stub)
  end

  def test_floating_ip_to_port

    stub = stub_request(:get, "https://example.com:12345/ports/00000000-0000-0000-0000-000000000000")
      .to_return(
        status: 200,
        body: <<-JSON,
        {
          "port": {
            "id": "00000000-0000-0000-0000-000000000000"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    fip = Yao::FloatingIP.new("port_id" => "00000000-0000-0000-0000-000000000000")

    assert_instance_of(Yao::Port, fip.port)
    assert_equal("00000000-0000-0000-0000-000000000000", fip.port.id)

    assert_requested(stub)
  end
end
