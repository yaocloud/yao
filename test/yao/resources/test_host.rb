class TestHost < Test::Unit::TestCase

  def test_host
    # https://docs.openstack.org/api-ref/compute/?expanded=list-flavors-detail,list-flavors-with-details-detail,list-hosts-detail#hosts-os-hosts-deprecated
    params = {
      "host_name" => "b6e4adbc193d428ea923899d07fb001e",
      "service" => "conductor",
      "zone" => "internal"
    }

    host = Yao::Host.new(params)

    # friendly_attributes
    assert_equal(host.host_name, "b6e4adbc193d428ea923899d07fb001e")
    assert_equal(host.service, "conductor")
    assert_equal(host.zone, "internal")
  end
end
