class TestUser < TestYaoResource
  def test_user
    params = {
      "id" => '1234567890',
      "name" => "test_user",
      "email" => "test-user@example.com",
      "password" => "passw0rd"
    }

    user = Yao::User.new(params)
    assert_equal("1234567890", user.id)
    assert_equal("test_user", user.name)
    assert_equal("test-user@example.com", user.email)
  end

  def test_role_assignment
    user_id = '123456'
    stub = stub_request(:get, "https://example.com:12345/role_assignments?user.id=#{user_id}").
      to_return(
        status: 200,
        body: <<-JSON,
        {
          "role_assignments": [{
            "scope": {
              "project": {
                "id": "aaaa166533fd49f3b11b1cdce2430000"
              }
            }
          }]
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    user = Yao::User.new('id' => user_id)
    role_assignment = user.role_assignment
    assert_equal('aaaa166533fd49f3b11b1cdce2430000', role_assignment.first.scope['project']['id'])
    assert_requested(stub)
  end

  sub_test_case 'with keystone v2.0' do
    def setup
      super
      Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v2.0")
    end

    def test_find_by_name
      stub = stub_request(:get, "https://example.com:12345/v2.0/users?name=test_user").
        to_return(
          status: 200,
          body: <<-JSON,
          {
            "user": {
              "email": "test-user@example.com",
              "enabled": true,
              "id": "u1000",
              "name": "test_user",
              "username": "test_user"
            }
          }
          JSON
          headers: {'Content-Type' => 'application/json'}
        )

        roles = Yao::User.find_by_name("test_user")
        assert_instance_of(Array, roles)
        assert_equal("u1000", roles.first.id)
        assert_requested(stub)
    end
  end

  sub_test_case 'with keystone v3' do
    def setup
      super
      Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v3")
    end

    def test_find_by_name
      stub = stub_request(:get, "https://example.com:12345/v3/users?name=test_user").
        to_return(
          status: 200,
          body: <<-JSON,
          {
            "links": {
              "next": null,
              "previous": null,
              "self": "http://example.com:12345/v3/users"
            },
            "users": [
                {
                    "domain_id": "default",
                    "enabled": true,
                    "id": "2844b2a08be147a08ef58317d6471f1f",
                    "links": {
                        "self": "http://example.com:12345/v3/users/2844b2a08be147a08ef58317d6471f1f"
                    },
                    "name": "test_user",
                    "password_expires_at": null
                }
            ]
          }
          JSON
          headers: {'Content-Type' => 'application/json'}
        )

        roles = Yao::User.find_by_name("test_user")
        assert_instance_of(Array, roles)
        assert_equal("2844b2a08be147a08ef58317d6471f1f", roles.first.id)
        assert_requested(stub)
    end
  end
end
