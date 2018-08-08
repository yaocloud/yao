require 'yao/resources/metadata_available'
require 'yao/resources/action'
module Yao::Resources
  class Server < Base
    friendly_attributes :addresses, :metadata, :name, :progress,
                        :status, :tenant_id, :user_id, :key_name
    map_attribute_to_attribute hostId: :host_id
    map_attribute_to_resource  flavor: Flavor
    map_attribute_to_resource  image: Image
    map_attribute_to_resources security_groups: SecurityGroup

    map_attribute_to_attribute 'OS-EXT-AZ:availability_zone'         => :availability_zone
    map_attribute_to_attribute 'OS-DCF:diskConfig'                   => :dcf_disk_config
    map_attribute_to_attribute 'OS-EXT-SRV-ATTR:host'                => :ext_srv_attr_host
    map_attribute_to_attribute 'OS-EXT-SRV-ATTR:hypervisor_hostname' => :ext_srv_attr_hypervisor_hostname
    map_attribute_to_attribute 'OS-EXT-SRV-ATTR:instance_name'       => :ext_srv_attr_instance_name
    map_attribute_to_attribute 'OS-EXT-STS:power_state'              => :ext_sts_power_state
    map_attribute_to_attribute 'OS-EXT-STS:task_state'               => :ext_sts_task_state
    map_attribute_to_attribute 'OS-EXT-STS:vm_state'                 => :ext_sts_vm_state

    self.service        = "compute"
    self.resource_name  = "server"
    self.resources_name = "servers"

    def old_samples(counter_name: nil, query: {})
      Yao::OldSample.list(counter_name, query).select{|os| os.resource_metadata["instance_id"] == id}
    end

    def self.start(id)
      action(id, "os-start" => nil)
    end

    def self.shutoff(id)
      action(id, "os-stop" => nil)
    end

    def self.reboot(id)
      action(id,"reboot" => { "type" => "HARD" })
    end

    def self.resize(id, flavor_id)
      action(id,"resize" => { "flavorRef" => flavor_id })
    end

    def self.add_security_group(id, sg_name)
      action(id, {"addSecurityGroup": {"name": sg_name}})
    end

    def self.remove_security_group(id, sg_name)
      action(id, {"removeSecurityGroup": {"name": sg_name}})
    end

    class << self
      alias :stop :shutoff

      def list_detail(query={})
        return_resources(
          resources_from_json(
            GET([resources_path, "detail"].join("/"), query).body
          )
        )
      end
    end

    extend MetadataAvailable
    extend Action
  end
end
