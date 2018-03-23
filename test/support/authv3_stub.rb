module AuthV3Stub
  def stub_auth_request(auth_url, username, password, tenant, user_domain_name, project_domain_name)
    stub_request(:post, "#{auth_url}/auth/tokens")
      .with(
        body: auth_json(username, password, tenant, user_domain_name, project_domain_name)
      ).to_return(
        :status => 200,
        :body => response_json(auth_url, username, tenant, user_domain_name, project_domain_name),
        :headers => {
          'Content-Type' => 'application/json',
          'X-Subject-Token' => 'aaaa166533fd49f3b11b1cdce2430000'
        }
      )
  end

  private

  def auth_json(username, password, tenant, user_domain_name, project_domain_name)
    json = <<-JSON
{"auth":{"identity":{"methods":["password"],"password":{"user":{"name":"#{username}","password":"XXXXXXXX","domain":{"name":"#{user_domain_name}"}}}},"scope":{"project":{"name":"#{tenant}","domain":{"name":"#{project_domain_name}"}}}}}
    JSON

    json.strip
  end

  def response_json(auth_url, username, tenant, user_domain_name, project_domain_name)
    <<-JSON
{
  "token": {
    "methods": ["password"],
    "roles": [{
      "id": "aaaa166533fd49f3b11b1cdce2430000",
      "name": "admin"
    }],
    "issued_at": "#{Time.now.iso8601}",
    "expires_at": "#{(Time.now + 3600).utc.iso8601}",
    "project": {
      "domain": {
        "id": "aaaa166533fd49f3b11b1cdce2430000",
        "name": "#{project_domain_name}"
      },
      "id": "aaaa166533fd49f3b11b1cdce2430000",
      "name": "#{project_domain_name}"
    },
    "catalog": [
      {
        "endpoints": [
          {
            "region_id": "RegionOne",
            "url": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionOne",
            "interface": "internal",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9"
          },
          {
            "region_id": "RegionOne",
            "url": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionOne",
            "interface": "public",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9"
          },
          {
            "region_id": "RegionOne",
            "url": "http://nova-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionOne",
            "interface": "admin",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionTest",
            "interface": "internal",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionTest",
            "interface": "public",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:8774/v2/b598bf98671c47e1b955f8c9660e3c44",
            "region": "RegionTest",
            "interface": "admin",
            "id": "1a66e6af97c440b2a7bbc4f9735923d9"
          }
        ],
        "type": "compute",
        "id": "a226b3eeb5594f50bf8b6df94636ed28",
        "name": "nova"
      },
      {
        "endpoints": [
          {
            "region_id": "RegionOne",
            "url": "http://neutron-endpoint.example.com:9696/",
            "region": "RegionOne",
            "interface": "internal",
            "id": "0418104da877468ca65d739142fa3454"
          },
          {
            "region_id": "RegionOne",
            "url": "http://neutron-endpoint.example.com:9696/",
            "region": "RegionOne",
            "interface": "public",
            "id": "0418104da877468ca65d739142fa3454"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9696/",
            "region": "RegionTest",
            "interface": "admin",
            "id": "0418104da877468ca65d739142fa3454"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9696/",
            "region": "RegionTest",
            "interface": "internal",
            "id": "0418104da877468ca65d739142fa3454"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9696/",
            "region": "RegionTest",
            "interface": "public",
            "id": "0418104da877468ca65d739142fa3454"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9696/",
            "region": "RegionTest",
            "interface": "admin",
            "id": "0418104da877468ca65d739142fa3454"
          }
        ],
        "type": "network",
        "id": "67b993549db94296a853d635b48db3c9",
        "name": "neutron"
      },
      {
        "endpoints": [
          {
            "region_id": "RegionOne",
            "url": "http://glance-endpoint.example.com:9292",
            "region": "RegionOne",
            "interface": "internal",
            "id": "246f33509ff64802b86eb081307ecec0"
          },
          {
            "region_id": "RegionOne",
            "url": "http://glance-endpoint.example.com:9292",
            "region": "RegionOne",
            "interface": "public",
            "id": "246f33509ff64802b86eb081307ecec0"
          },
          {
            "region_id": "RegionOne",
            "url": "http://glance-endpoint.example.com:9292",
            "region": "RegionOne",
            "interface": "admin",
            "id": "246f33509ff64802b86eb081307ecec0"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9292",
            "region": "RegionTest",
            "interface": "internal",
            "id": "246f33509ff64802b86eb081307ecec0"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9292",
            "region": "RegionTest",
            "interface": "public",
            "id": "246f33509ff64802b86eb081307ecec0"
          },
          {
            "region_id": "RegionTest",
            "url": "http://global-endpoint.example.com:9292",
            "region": "RegionOne",
            "interface": "admin",
            "id": "246f33509ff64802b86eb081307ecec0"
          }
        ],
        "type": "image",
        "id": "d512f8860c0f45cf99b1c3cef86cfd97",
        "name": "glance"
      },
      {
        "endpoints": [
          {
            "region_id": "RegionOne",
            "url": "http://endpoint.example.com:5000/v2.0",
            "region": "RegionOne",
            "interface": "internal",
            "id": "2b982236cc084128bf42b647c1b7fb49"
          },
          {
            "region_id": "RegionOne",
            "url": "http://endpoint.example.com:5000/v2.0",
            "region": "RegionOne",
            "interface": "public",
            "id": "2b982236cc084128bf42b647c1b7fb49"
          },
          {
            "region_id": "RegionOne",
            "url": "#{auth_url}",
            "region": "RegionOne",
            "interface": "admin",
            "id": "2b982236cc084128bf42b647c1b7fb49"
          },
          {
            "region_id": "RegionTest",
            "url": "https://global-endpoint.example.com/api/keystone/",
            "region": "RegionTest",
            "interface": "internal",
            "id": "2b982236cc084128bf42b647c1b7fb49"
          },
          {
            "region_id": "RegionTest",
            "url": "https://global-endpoint.example.com/api/keystone/",
            "region": "RegionTest",
            "interface": "public",
            "id": "2b982236cc084128bf42b647c1b7fb49"
          },
          {
            "region_id": "RegionTest",
            "url": "https://global-endpoint.example.com/api/admin/keystone/",
            "region": "RegionTest",
            "interface": "admin",
            "id": "2b982236cc084128bf42b647c1b7fb49"
          }
        ],
        "type": "identity",
        "id": "050726f278654128aba89757ae25950c",
        "name": "keystone"
      },
      {
        "endpoints": [
          {
            "region_id": "RegionOne",
            "internalurl": "http://octavia-endpoint.example.com:9876",
            "region": "RegionOne",
            "interface": "internal",
            "id": "bde3abca8864400a809f0089f025370a"
          },
          {
            "region_id": "RegionOne",
            "internalurl": "http://octavia-endpoint.example.com:9876",
            "region": "RegionOne",
            "interface": "public",
            "id": "bde3abca8864400a809f0089f025370a"
          },
          {
            "region_id": "RegionOne",
            "internalurl": "http://octavia-endpoint.example.com:9876",
            "region": "RegionOne",
            "interface": "admin",
            "id": "bde3abca8864400a809f0089f025370a"
          },
          {
            "region_id": "RegionTest",
            "internalurl": "http://global-endpoint.example.com:9876",
            "region": "RegionTest",
            "interface": "internal",
            "id": "bde3abca8864400a809f0089f025370a"
          },
          {
            "region_id": "RegionTest",
            "internalurl": "http://global-endpoint.example.com:9876",
            "region": "RegionTest",
            "interface": "public",
            "id": "bde3abca8864400a809f0089f025370a"
          },
          {
            "region_id": "RegionTest",
            "internalurl": "http://global-endpoint.example.com:9876",
            "region": "RegionTest",
            "interface": "admin",
            "id": "bde3abca8864400a809f0089f025370a"
          }
        ],
        "type": "load-balancer",
        "id": "a5f7070bda40443fa3819fbdf1689af1",
        "name": "octavia"
      }
    ],
    "user": {
      "domain": {
        "id": "a9994b2dee82423da7da572397d3157a",
        "name": "#{user_domain_name}"
      },
      "name": "#{username}",
      "id": "a9994b2dee82423da7da572397d3157a",
      "name": "#{username}"
    },
    "audit_ids": [
      "3t2dc1cgqxyjshddu1xkcw"
    ]
  }
}
    JSON
  end
end
