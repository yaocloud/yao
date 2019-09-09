class TestRole < TestYaoResource
  def test_role_attributes
    params = {
      "name" => "test_role",
      "description" => "test_description_1"
    }

    role = Yao::Role.new(params)
    assert_equal(role.name, "test_role")
    assert_equal(role.description, "test_description_1")
  end
end
