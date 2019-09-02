class TestUser < TestYaoResouce
  def test_sg_attributes
    params = {
      "name" => "test_user",
      "email" => "test-user@example.com",
      "password" => "passw0rd"
    }

    user = Yao::User.new(params)
    assert_equal(user.name, "test_user")
    assert_equal(user.email, "test-user@example.com")
  end
end
