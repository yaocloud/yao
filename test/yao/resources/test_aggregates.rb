class TestAggregates < TestYaoResource
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
    assert_equal("nova", aggregates.availability_zone)
    assert_equal(false, aggregates.deleted)
    assert_equal(["host1", "host2"], aggregates.hosts)
    assert_equal({"foo" => "bar"}, aggregates.metadata)
    assert_equal("nova", aggregates.name)
    assert_equal(Time.parse("2015-08-27T09:49:58-05:00"), aggregates.created)
    assert_equal(Time.parse("2015-08-27T09:49:58-05:00"), aggregates.updated)
    assert_equal(Date.parse("2015-08-27T09:49:58-05:00"), aggregates.deleted_at)
  end
end
