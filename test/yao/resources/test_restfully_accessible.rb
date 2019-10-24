class TestRestfullyAccesible < Test::Unit::TestCase
  include RestfullAccessibleStub
  class Test
    class << self
      attr_accessor :client
    end
    extend Yao::Resources::RestfullyAccessible
  end

  def setup
    @url = "https://example.com:12345"
    @resource_name  = "dummy_resource"
    @resources_name = "dummy_resources"

    Test.resource_name  = @resource_name
    Test.resources_name = @resources_name
    Test.client = Yao::Client.gen_client(@url)
  end

  sub_test_case 'get' do
    test 'permalink' do
      stub_get_request("https://example.com/dummy_resource", @resource_name)
      mock(Test).new("dummy_resource") { "OK" }
      assert_equal("OK", Test.get("https://example.com/dummy_resource"))
    end

    test 'uuid' do
      uuid = "00112233-4455-6677-8899-aabbccddeeff"
      stub_get_request([@url, @resources_name, uuid].join('/'), @resource_name)
      mock(Test).new("dummy_resource") { "OK" }
      assert_equal("OK", Test.get(uuid))
    end

    test 'id (not uuid)' do
      id = "1"
      stub_get_request([@url, @resources_name, id].join('/'), @resource_name)
      mock(Test).new("dummy_resource") { "OK" }
      assert_equal("OK", Test.get(id))
    end

    test 'name' do
      Test.return_single_on_querying = true
      name = "dummy"
      uuid = "00112233-4455-6677-8899-aabbccddeeff"

      stub_get_request_not_found([@url, @resources_name, name].join('/'))
      stub_get_request([@url, "#{@resources_name}?name=dummy"].join('/'), @resources_name)
      mock(Test).new("dummy_resource") { Struct.new(:id).new(uuid) }
      stub_get_request([@url, @resources_name, uuid].join('/'), @resources_name)
      mock(Test).new("dummy_resource") { "OK" }

      assert_equal("OK", Test.get(name))
    end
  end

  def test_find_by_name
    mock(Test).list({"name" => "dummy"}) { "dummy" }

    assert_equal("dummy", Test.find_by_name("dummy"))
  end

  def test_uuid?
    assert_equal(true, Test.send(:uuid?, "00112233-4455-6677-8899-aabbccddeeff"))

    # not uuid
    assert_equal(false, Test.send(:uuid?, "dummy resource"))
    assert_equal(false, Test.send(:uuid?, "00112233445566778899aabbccddeeff"))
  end
end
