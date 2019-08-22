class TestRoleAssignment < Test::Unit::TestCase

  def setup
    Yao.default_client.pool["compute"] = Yao::Client.gen_client("https://example.com:12345")
  end

  def test_role_assignment

    # https://docs.openstack.org/api-ref/identity/v3/?expanded=validate-and-show-information-for-token-detail,list-role-assignments-detail#list-role-assignments
    params = {
      "links" => {
        "assignment" => "http://example.com/identity/v3/domains/161718/users/313233/roles/123456"
      },
      "role" => {
        "id" => "123456"
      },
      "scope" => {
        "project" => {
          "id" => "456789"
        }
      },
      "user" => {
        "id" => "313233"
      }
    }

    role_assignment = Yao::RoleAssignment.new(params)
    assert_equal(role_assignment.scope, { "project" => { "id" => "456789" } })

    # map_attribute_to_resource
    assert_instance_of(Yao::Resources::Role, role_assignment.role)
    assert_equal(role_assignment.role.id, "123456")

    # map_attribute_to_resource
    assert_instance_of(Yao::Resources::User, role_assignment.user)
    assert_equal(role_assignment.user.id, "313233")
  end

  def test_project
    stub_request(:get, "http://endpoint.example.com:12345/tenants/456789").
      to_return(
        status: 200,
        body: <<-JSON,
        {
          "tenant": {
            "id": "456789"
          }
        }
        JSON
        headers: {'Content-Type' => 'application/json'}
      )

    params = {
      "scope" => {
        "project" => {
          "id" => "456789"
        }
      },
    }

    role_assignment = Yao::RoleAssignment.new(params)
    assert_instance_of(Yao::Resources::Tenant, role_assignment.project)
    assert_equal(role_assignment.project.id, "456789")
  end
end
