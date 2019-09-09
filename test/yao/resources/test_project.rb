class TestProject < TestYaoResouce
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
    assert_equal(project.domain?, false)
    assert_equal(project.description, nil)
    assert_equal(project.domain_id, "default")
    assert_equal(project.enabled?, true)
    assert_equal(project.id, "0c4e939acacf4376bdcd1129f1a054ad")
    assert_equal(project.name, "admin")
    assert_equal(project.parent_id, nil)
  end
end