class TestRole < TestYaoResouce
  def test_role_attributes
    params = {
      "name" => "test_role",
      "description" => "test_description_1"
    }

    role = Yao::Role.new(params)
    assert_equal(role.name, "test_role")
    assert_equal(role.description, "test_description_1")
  end

  sub_test_case 'with keystone v2.0' do

    def setup
      super
      Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v2.0")
    end

    def test_resource_path
      stub = stub_request(:get, "https://example.com:12345/v2.0/OS-KSADM/roles").
        to_return(
          status: 200,
          body: <<-JSON,
          {
            "roles": [{
              "id": "0123456789abcdef0123456789abcdef",
              "name": "admin"
            }]
          }
          JSON
          headers: {'Content-Type' => 'application/json'}
        )

      roles = Yao::Role.list

      assert_instance_of(Yao::Role, roles.first)
      assert_equal(roles.first.id, "0123456789abcdef0123456789abcdef")
      assert_requested(stub)
    end
  end

  sub_test_case 'with keystone v3.0' do

    def setup
      super
      Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v3")
    end

    def test_resource_path
      stub = stub_request(:get, "https://example.com:12345/v3/roles").
        to_return(
          status: 200,
          body: <<-JSON,
          {
            "roles": [{
              "id": "0123456789abcdef0123456789abcdef",
              "name": "admin"
            }]
          }
          JSON
          headers: {'Content-Type' => 'application/json'}
        )

      roles = Yao::Role.list

      assert_instance_of(Yao::Role, roles.first)
      assert_equal(roles.first.id, "0123456789abcdef0123456789abcdef")
      assert_requested(stub)
    end
  end
end
