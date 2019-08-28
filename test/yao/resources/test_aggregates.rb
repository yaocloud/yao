class TestAggregates < TestYaoResouce
  def test_server_aggregates
    params = {
      "availability_zone" => "nova",
      "deleted" => false,
      "hosts" => ["host1", "host2"],
      "metadata" => {"foo" => "bar"},
      "name" => "nova",
      "created_at" => "2015-08-27T09:49:58-05:00",
      "updated_at" => "2015-08-27T09:49:58-05:00",
      "deleted_at" => "2015-08-27T09:49:58-05:00",
    }

    aggregates = Yao::Aggregates.new(params)
    assert_equal(aggregates.availability_zone, "nova")
    assert_equal(aggregates.deleted, false)
    assert_equal(aggregates.hosts, ["host1", "host2"])
    assert_equal(aggregates.metadata, {"foo" => "bar"})
    assert_equal(aggregates.name, "nova")
    assert_equal(aggregates.created, Time.parse("2015-08-27T09:49:58-05:00"))
    assert_equal(aggregates.updated, Time.parse("2015-08-27T09:49:58-05:00"))
    assert_equal(aggregates.deleted_at, Date.parse("2015-08-27T09:49:58-05:00"))
  end
end
