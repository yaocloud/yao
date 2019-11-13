class TestNetworkingAgents < TestYaoResource

  def test_networking_agents

    # https://docs.openstack.org/api-ref/network/v2/?expanded=list-all-agents-detail#list-all-agents
    params = {
      "binary" => "neutron-openvswitch-agent",
      "description" => "aaa bbb ccc",
      "availability_zone" => "zone",
      "heartbeat_timestamp" => "2017-09-12 19:40:08",
      "admin_state_up" => true,
      "alive" => true,
      "id" => "04c62b91-b799-48b7-9cd5-2982db6df9c6",
      "topic" => "N/A",
      "host" => "agenthost1",
      "agent_type" => "Open vSwitch agent",
      "started_at" => "2017-09-12 19:35:38",
      "created_at" => "2017-09-12 19:35:38",
      "resources_synced" => true,
      "configurations" => {
        "ovs_hybrid_plug" => true,
        "in_distributed_mode" => false,
        "datapath_type" => "system",
        "vhostuser_socket_dir" => "/var/run/openvswitch",
        "tunneling_ip" => "172.16.78.191",
        "arp_responder_enabled" => false,
        "devices" => 0,
        "ovs_capabilities" => {
          "datapath_types" => [
            "netdev",
            "system"
          ],
          "iface_types" => [
            "geneve",
            "gre",
            "internal",
            "ipsec_gre",
            "lisp",
            "patch",
            "stt",
            "system",
            "tap",
            "vxlan"
          ]
        },
        "log_agent_heartbeats" => false,
        "l2_population" => false,
        "tunnel_types" => [
          "vxlan"
        ],
        "extensions" => [
        ],
        "enable_distributed_routing" => false,
        "bridge_mappings" => {
          "public" => "br-ex"
        }
      }
    }

    agent = Yao::NetworkingAgents.new(params)

    # friendly_attributes
    assert_equal("04c62b91-b799-48b7-9cd5-2982db6df9c6", agent.id)
    assert_equal(true, agent.admin_state_up)
    assert_equal("Open vSwitch agent", agent.agent_type)
    assert_equal(true, agent.alive)
    assert_equal("zone", agent.availability_zone)
    assert_equal("neutron-openvswitch-agent", agent.binary)

    # configurations is a complex Hash, so limit testing only one key.
    assert_instance_of(Hash, agent.configurations)
    assert_equal("172.16.78.191", agent.configurations['tunneling_ip'])

    assert_equal("aaa bbb ccc", agent.description)
    assert_equal("agenthost1", agent.host)
    assert_equal(true, agent.resources_synced)
    assert_equal("N/A", agent.topic)

    assert_equal(Time.parse("2017-09-12 19:40:08"), agent.heartbeat_timestamp)
    assert_equal(Time.parse("2017-09-12 19:35:38"), agent.created_at)
    assert_equal(Time.parse("2017-09-12 19:35:38"), agent.started_at)
  end
end
