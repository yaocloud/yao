class TestOnly < Test::Unit::TestCase

  AUTH_JSON = \
    "{\"auth\":{\"passwordCredentials\":{\"username\":\"udzura\",\"password\":\"XXXXXXXX\"},\"tenantName\":\"example\"}}"

  RESPONSE_JSON = <<-JSON
{
  "access": {
    "token": {
      "issued_at": "2015-08-31T03:58:36.073232",
      "expires": "2015-09-01T03:58:36Z",
      "id": "aaaa166533fd49f3b11b1cdce2430000",
      "tenant": {
        "description": "Testing",
        "enabled": true,
        "id": "aaaa166533fd49f3b11b1cdce2430000",
        "name": "example"
      }
    },
    "serviceCatalog": [
      {
        "endpoints": [
          {
            "adminURL": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionOne",
            "internalURL": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9",
            "publicURL": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44"
          }
        ],
        "endpoints_links": [],
        "type": "compute",
        "name": "nova"
      },
      {
        "endpoints": [
          {
            "adminURL": "http://neutron-endpoint.example.com:9696/",
            "region": "RegionOne",
            "internalURL": "http://neutron-endpoint.example.com:9696/",
            "id": "0418104da877468ca65d739142fa3454",
            "publicURL": "http://neutron-endpoint.example.com:9696/"
          }
        ],
        "endpoints_links": [],
        "type": "network",
        "name": "neutron"
      },
      {
        "endpoints": [
          {
            "adminURL": "http://glance-endpoint.example.com:9292",
            "region": "RegionOne",
            "internalURL": "http://glance-endpoint.example.com:9292",
            "id": "246f33509ff64802b86eb081307ecec0",
            "publicURL": "http://glance-endpoint.example.com:9292"
          }
        ],
        "endpoints_links": [],
        "type": "image",
        "name": "glance"
      },
      {
        "endpoints": [
          {
            "adminURL": "http://endpoint.example.com:12345/v2.0",
            "region": "RegionOne",
            "internalURL": "http://endpoint.example.com:5000/v2.0",
            "id": "2b982236cc084128bf42b647c1b7fb49",
            "publicURL": "http://endpoint.example.com:5000/v2.0"
          }
        ],
        "endpoints_links": [],
        "type": "identity",
        "name": "keystone"
      }
    ],
    "user": {
      "username": "udzura",
      "roles_links": [],
      "id": "a9994b2dee82423da7da572397d3157a",
      "roles": [
        {
          "name": "admin"
        }
      ],
      "name": "udzura"
    },
    "metadata": {
      "is_admin": 0,
      "roles": [
        "ce5330c512cc4bd289b3a725ad1106b7"
      ]
    }
  }
}
  JSON

  def setup
    auth_url = "http://endpoint.example.com:12345"
    name = "udzura"

    stub_request(:post, "#{auth_url}/v2.0/tokens").with(body: AUTH_JSON)
      .to_return(:status => 200, :body => RESPONSE_JSON, :headers => {'Content-Type' => 'application/json'})

    Yao.configure do
      auth_url auth_url
      username name
      tenant_name "example"
      password "XXXXXXXX"
    end

    @name = name
    @get_stub  = stub_request(:get,  "#{auth_url}/v2.0/users?name=#{name}")
    @post_stub = stub_request(:post, "#{auth_url}/v2.0/users")
  end

  def test_read_only
    Yao.read_only do
      Yao::User.get_by_name(@name)
      Yao::User.create(name: "foo", email: "bar", password: "baz")
    end

    assert_requested @get_stub
    assert_not_requested @post_stub
  end

  def test_read_only!
    assert_raise Yao::GetOnlyViolationError do
      Yao.read_only! do
        Yao::User.get_by_name(@name)
        Yao::User.create(name: "foo", email: "bar", password: "baz")
      end
    end

    assert_requested @get_stub
    assert_not_requested @post_stub
  end
end
