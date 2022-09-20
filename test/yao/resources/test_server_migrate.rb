class TestServerGroup < TestYaoResource
  def test_server_migrate
    # https://docs.openstack.org/api-ref/compute/?expanded=list-migrations-detail#list-migrations
    params = {
      "created_at" => "2012-10-29T13:42:02.000000",
      "dest_compute" => "compute2",
      "dest_host" => "1.2.3.4",
      "dest_node" => "node2",
      "id" => 1234,
      "instance_uuid" => "8600d31b-d1a1-4632-b2ff-45c2be1a70ff",
      "new_instance_type_id" => 2,
      "old_instance_type_id" => 1,
      "source_compute" => "compute1",
      "source_node" => "node1",
      "status" => "done",
      "updated_at" => "2012-10-29T13:42:02.000000"
    }

    migrate = Yao::ServerMigrate.new(params)
    assert_equal(Time.parse("2012-10-29T13:42:02.000000"), migrate.created_at)
    assert_equal("compute2", migrate.dest_compute)
    assert_equal("1.2.3.4", migrate.dest_host)
    assert_equal("node2", migrate.dest_node)
    assert_equal(1234, migrate.id)
    assert_equal("8600d31b-d1a1-4632-b2ff-45c2be1a70ff", migrate.server_id)
    assert_equal(2, migrate.new_instance_type_id)
    assert_equal(1, migrate.old_instance_type_id)
    assert_equal("compute1", migrate.source_compute)
    assert_equal("node1", migrate.source_node)
    assert_equal("done", migrate.status)
    assert_equal(Time.parse("2012-10-29T13:42:02.000000"), migrate.updated_at)
  end
end
