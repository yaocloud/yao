class TestRoleAssignment < TestYaoResource

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
    assert_equal({ "project" => { "id" => "456789" } }, role_assignment.scope)

    # map_attribute_to_resource
    assert_instance_of(Yao::Resources::Role, role_assignment.role)
    assert_equal("123456", role_assignment.role.id)

    # map_attribute_to_resource
    assert_instance_of(Yao::Resources::User, role_assignment.user)
    assert_equal("313233", role_assignment.user.id)
  end

  def test_list
    stub = stub_request(:get, "https://example.com:12345/role_assignments").
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
    role_assignment = Yao::RoleAssignment.list
    assert_equal('aaaa166533fd49f3b11b1cdce2430000', role_assignment.first.scope['project']['id'])
    assert_requested(stub)
  end

  def test_project
    stub = stub_request(:get, "https://example.com:12345/tenants/456789").
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
    assert_equal("456789", role_assignment.project.id)

    assert_requested(stub)
  end
end
