class TestRole < TestYaoResource
  def test_role_attributes
    params = {
      "name" => "test_role",
      "description" => "test_description_1"
    }

    role = Yao::Role.new(params)
    assert_equal("test_role", role.name)
    assert_equal("test_description_1", role.description)
  end

  sub_test_case 'with keystone v2.0' do

    def setup
      super
      Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v2.0")
    end

    def test_find_by_name
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

      roles = Yao::Role.find_by_name("admin")

      assert_instance_of(Yao::Role, roles.first)
      assert_equal("0123456789abcdef0123456789abcdef", roles.first.id)
      assert_requested(stub)
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
      assert_equal("0123456789abcdef0123456789abcdef", roles.first.id)
      assert_requested(stub)
    end

    def test_list_for_user
      stub_user
      stub_tenant
      stub = stub_request(:get, "https://example.com:12345/v2.0/tenants/0123456789abcdef0123456789abcdef/users/2844b2a08be147a08ef58317d6471f1f/roles").
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

      roles = Yao::Role.list_for_user("test_user", on:"admin")
      assert_equal("0123456789abcdef0123456789abcdef", roles.first.id)
      assert_received(Yao::User) { |subject| subject.get("test_user") }
      assert_received(Yao::Tenant) { |subject| subject.get("admin") }
      assert_requested(stub)
    end

    def test_grant
      stub_role
      stub_user
      stub_tenant
      stub = stub_request(:put, "https://example.com:12345/v2.0/tenants/0123456789abcdef0123456789abcdef/users/2844b2a08be147a08ef58317d6471f1f/roles/OS-KSADM/5318e65d75574c17bf5339d3df33a5a3").
        to_return(
          status: 204,
          body: "",
          headers: {'Content-Type' => 'application/json'}
        )

      Yao::Role.grant("test_role", to:"test_user", on:"admin")
      assert_received(Yao::Role) { |subject| subject.get("test_role") }
      assert_received(Yao::User) { |subject| subject.get("test_user") }
      assert_received(Yao::Tenant) { |subject| subject.get("admin") }
      assert_requested(stub)
    end

    def test_revoke
      stub_role
      stub_user
      stub_tenant
      stub = stub_request(:delete, "https://example.com:12345/v2.0/tenants/0123456789abcdef0123456789abcdef/users/2844b2a08be147a08ef58317d6471f1f/roles/OS-KSADM/5318e65d75574c17bf5339d3df33a5a3").
        to_return(
          status: 204,
          body: "",
          headers: {'Content-Type' => 'application/json'}
        )

      Yao::Role.revoke("test_role", from:"test_user", on:"admin")
      assert_received(Yao::Role) { |subject| subject.get("test_role") }
      assert_received(Yao::User) { |subject| subject.get("test_user") }
      assert_received(Yao::Tenant) { |subject| subject.get("admin") }
      assert_requested(stub)
    end
  end

  sub_test_case 'with keystone v3' do

    def setup
      super
      Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v3")
    end

    def test_find_by_name
      stub = stub_request(:get, "https://example.com:12345/v3/roles?name=admin").
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

      roles = Yao::Role.find_by_name("admin")

      assert_instance_of(Yao::Role, roles.first)
      assert_equal("0123456789abcdef0123456789abcdef", roles.first.id)
      assert_requested(stub)
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
      assert_equal("0123456789abcdef0123456789abcdef", roles.first.id)
      assert_requested(stub)
    end

    def test_list_for_user
      stub_user
      stub_project
      stub = stub_request(:get, "https://example.com:12345/v3/projects/0123456789abcdef0123456789abcdef/users/2844b2a08be147a08ef58317d6471f1f/roles").
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

      roles = Yao::Role.list_for_user("test_user", on:"admin")
      assert_equal("0123456789abcdef0123456789abcdef", roles.first.id)
      assert_received(Yao::Resources::User) { |subject| subject.get("test_user") }
      assert_received(Yao::Resources::Project) { |subject| subject.get("admin") }
      assert_requested(stub)
    end

    def test_grant
      stub_role
      stub_user
      stub_project
      stub = stub_request(:put, "https://example.com:12345/v3/projects/0123456789abcdef0123456789abcdef/users/2844b2a08be147a08ef58317d6471f1f/roles/5318e65d75574c17bf5339d3df33a5a3").
        to_return(
          status: 204,
          body: "",
          headers: {'Content-Type' => 'application/json'}
        )

      Yao::Role.grant("test_role", to:"test_user", on:"admin")
      assert_received(Yao::Role) { |subject| subject.get("test_role") }
      assert_received(Yao::User) { |subject| subject.get("test_user") }
      assert_received(Yao::Project) { |subject| subject.get("admin") }
      assert_requested(stub)
    end

    def test_revoke
      stub_role
      stub_user
      stub_project
      stub = stub_request(:delete, "https://example.com:12345/v3/projects/0123456789abcdef0123456789abcdef/users/2844b2a08be147a08ef58317d6471f1f/roles/5318e65d75574c17bf5339d3df33a5a3").
        to_return(
          status: 204,
          body: "",
          headers: {'Content-Type' => 'application/json'}
        )

      Yao::Role.revoke("test_role", from:"test_user", on:"admin")
      assert_received(Yao::Role) { |subject| subject.get("test_role") }
      assert_received(Yao::User) { |subject| subject.get("test_user") }
      assert_received(Yao::Project) { |subject| subject.get("admin") }
      assert_requested(stub)
    end
  end

  private
  def stub_role
    stub(Yao::Role).get { Yao::Role.new(
      "id" => "5318e65d75574c17bf5339d3df33a5a3",
      "name" => "test_role",
      "description" => "test_description_1"
    )}
  end

  def stub_user
    stub(Yao::User).get { Yao::User.new({
      "id" => "2844b2a08be147a08ef58317d6471f1f",
      "name" => "test_user",
    }) }
  end

  def stub_tenant
    stub(Yao::Tenant).get { Yao::Tenant.new({
      "id" => "0123456789abcdef0123456789abcdef",
      "name" => "admin",
    }) }
  end

  def stub_project
    stub(Yao::Project).get { Yao::Tenant.new({
      "id" => "0123456789abcdef0123456789abcdef",
      "name" => "admin",
    }) }
  end
end
