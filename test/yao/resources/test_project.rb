class TestProject < TestYaoResource
  def setup
    super
    Yao.default_client.admin_pool["identity"] = Yao::Client.gen_client("https://example.com:12345/v2.0")
  end

  # https://docs.openstack.org/api-ref/identity/v3/?expanded=list-projects-detail#projects
  def test_project
    params = {
      "is_domain" => false,
      "description" => nil,
      "domain_id" => "default",
      "enabled" => true,
      "id" => "0c4e939acacf4376bdcd1129f1a054ad",
      "links" => {
        "self" => "http://example.com/identity/v3/projects/0c4e939acacf4376bdcd1129f1a054ad"
      },
      "name" => "admin",
      "parent_id" => nil,
      "tags" => []
    }

    project = Yao::Project.new(params)
    assert_equal(false, project.domain?)
    assert_equal(nil, project.description)
    assert_equal("default", project.domain_id)
    assert_equal(true, project.enabled?)
    assert_equal("0c4e939acacf4376bdcd1129f1a054ad", project.id)
    assert_equal("admin", project.name)
    assert_equal(nil, project.parent_id)
  end
end