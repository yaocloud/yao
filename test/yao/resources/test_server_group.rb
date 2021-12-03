class TestServerGroup < TestYaoResource
  def test_server_group
    # https://docs.openstack.org/api-ref/compute/?expanded=list-server-groups-detail,show-server-group-details-detail#list-server-groups
    params = {
      "id" => "616fb98f-46ca-475e-917e-2563e5a8cd19",
      "name" => "test",
      "policy" => "anti-affinity",
      "rules" => {"max_server_per_host" => 3},
      "members" => [],
      "project_id" => "6f70656e737461636b20342065766572",
      "user_id" => "fake"
    }

    sg = Yao::ServerGroup.new(params)
    assert_equal("616fb98f-46ca-475e-917e-2563e5a8cd19", sg.id)
    assert_equal("test", sg.name)
    assert_equal("anti-affinity", sg.policy)
    assert_equal({"max_server_per_host" => 3}, sg.rules)
    assert_equal([], sg.members)
    assert_equal("6f70656e737461636b20342065766572", sg.project_id)
    assert_equal("fake", sg.user_id)
  end
end
