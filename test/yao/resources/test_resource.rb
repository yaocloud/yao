class TestResource < TestYaoResource

  def test_resource

    # https://docs.openstack.org/ceilometer/pike/webapi/v2.html#Resource
    params = {
      "links" =>[
        {
          "href" => "http://localhost:8777/v2/resources/bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
          "rel" => "self"
        },
        {
          "href" => "http://localhost:8777/v2/meters/volume?q.field=resource_id&q.value=bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
          "rel" => "volume"
        }
      ],
      "metadata" => {
        "name1" =>"value1",
        "name2" =>"value2"
      },
      "project_id" => "35b17138-b364-4e6a-a131-8f3099c5be68",
      "resource_id" => "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
      "source" => "openstack",
      "user_id" => "efd87807-12d2-4b38-9c70-5f5c2ac427ff",
      # uncodumented
      "last_sample_timestamp" => "2019-08-29T08:41:22.555000",
      "first_sample_timestamp" => "2019-03-19T08:41:21.383000",
    }

    resource = Yao::Resources::Resource.new(params)

    assert_equal(resource.last_sample_timestamp, "2019-08-29T08:41:22.555000")
    assert_equal(resource.last_sampled_at, Time.parse("2019-08-29T08:41:22.555000"))

    assert_equal(resource.first_sample_timestamp, "2019-03-19T08:41:21.383000")
    assert_equal(resource.first_sampled_at, Time.parse("2019-03-19T08:41:21.383000"))

    assert_equal(resource.id, "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36")
    assert_equal(resource.resource_id, "bd9431c1-8d69-4ad3-803a-8d4a6b89fd36")
    assert_equal(resource.user_id, "efd87807-12d2-4b38-9c70-5f5c2ac427ff")
    assert_equal(resource.metadata, {
      "name1" =>"value1",
      "name2" =>"value2"
    })
    assert_equal(resource.links, [
      {
        "href" => "http://localhost:8777/v2/resources/bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
        "rel" => "self"
      },
      {
        "href" => "http://localhost:8777/v2/meters/volume?q.field=resource_id&q.value=bd9431c1-8d69-4ad3-803a-8d4a6b89fd36",
        "rel" => "volume"
      }
    ])
  end
end
