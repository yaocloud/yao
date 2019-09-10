class TestHost < TestYaoResource

  def test_host
    # https://docs.openstack.org/api-ref/compute/?expanded=list-flavors-detail,list-flavors-with-details-detail,list-hosts-detail#hosts-os-hosts-deprecated
    params = {
      "host_name" => "b6e4adbc193d428ea923899d07fb001e",
      "service" => "conductor",
      "zone" => "internal"
    }

    host = Yao::Host.new(params)

    # friendly_attributes
    assert_equal("b6e4adbc193d428ea923899d07fb001e", host.host_name)
    assert_equal("conductor", host.service)
    assert_equal("internal", host.zone)
  end
end
