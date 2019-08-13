class TestNetwork < Test::Unit::TestCase

  def test_network

    # https://docs.openstack.org/api-ref/network/v2/#networks
    params = {
      "admin_state_up" => true,
      "id" => "b3680498-03da-4691-896f-ef9ee1d856a7",
      "name" => "net1",
      "provider:network_type" => "vlan",
      "provider:physical_network" => "physnet1",
      "provider:segmentation_id" => 1000,
      "router:external" => false,
      "shared" => false,
      "status" => "ACTIVE",
      "subnets" => [],
      "tenant_id" => "c05140b3dc7c4555afff9fab6b58edc2",
      "project_id" => "c05140b3dc7c4555afff9fab6b58edc2",
    }

    network = Yao::Network.new(params)

    # friendly_attributes
    assert_equal(network.id, "b3680498-03da-4691-896f-ef9ee1d856a7")
    assert_equal(network.name, "net1")
    assert_equal(network.status, "ACTIVE")
    assert_equal(network.shared, false)
    assert_equal(network.shared?, false)
    assert_equal(network.tenant_id, "c05140b3dc7c4555afff9fab6b58edc2")
    assert_equal(network.subnets, [])
    assert_equal(network.admin_state_up, true)

    #map_attribute_to_attribute
    assert_equal(network.physical_network, "physnet1")
    assert_equal(network.type, "vlan")
    assert_equal(network.segmentation_id, 1000)
  end
end
