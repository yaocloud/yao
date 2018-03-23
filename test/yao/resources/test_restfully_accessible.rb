class TestRestfullyAccesible < Test::Unit::TestCase
  include Yao::Resources::RestfullyAccessible

  def test_get
    mock(self).find_by_name("dummy", {}) { Struct.new(:body).new("dummy") }
    mock(self).resource_from_json("dummy") { "dummy" }
    mock(self).return_resource("dummy") { "dummy" }

    get("dummy")
    RR.verify
  end

  def test_find_by_name
    mock(self).list({"name" => "dummy"}) { "dummy" }

    assert_equal(find_by_name("dummy"), "dummy")
  end

  def test_uuid?
    assert_equal(uuid?("00112233-4455-6677-8899-aabbccddeeff"), true)

    # not uuid
    assert_equal(uuid?("dummy resource"), false)
    assert_equal(uuid?("00112233445566778899aabbccddeeff"), false)
  end
end
