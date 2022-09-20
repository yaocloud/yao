require 'yao/resources/metadata_available'
require 'yao/resources/action'
module Yao::Resources
  class Server < Base
    include ProjectAssociationable

    friendly_attributes :addresses, :metadata, :name, :progress,
                        :status, :user_id, :key_name
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

    map_attributes_to_time :created, :updated
    alias :created_at :created
    alias :updated_at :updated

    self.service        = "compute"
    self.resource_name  = "server"
    self.resources_name = "servers"
    self.resources_detail_available = true

    # @param counter_name [String]
    # @param query [Hash]
    # @return [Array<Yao::OldSample>]
    def old_samples(counter_name: nil, query: {})
      Yao::OldSample.list(counter_name, query).select{|os| os.resource_metadata["instance_id"] == id}
    end

    # @return [Array<Yao::Resources::Port>]
    def ports
      @ports ||= Yao::Port.list(device_id: id)
    end

    # @return [Array<Yao::Resources::ServerMigrate>]
    def migrations
      Yao::ServerMigrate.get(id)
    end

    # @param id [String]
    # @return [Hash]
    def self.start(id)
      action(id, "os-start" => nil)
    end

    # @return [Hash]
    def start
      self.class.start(id)
    end

    # @return [Hash]
    def shutoff
      self.class.shutoff(id)
    end
    alias :stop :shutoff

    # @return [Hash]
    def reboot
      self.class.reboot(id)
    end

    # @return [Hash]
    def resize(flavor_id)
      self.class.resize(id, flavor_id)
    end

    # @param id [String]
    # @param host [String]
    # @param block_migration [Boolean]
    # @param disk_over_commit [Boolean]
    # @param opts [Hash]
    # @return [Hash]
    def live_migrate(host = nil, block_migration = false, disk_over_commit = false, opts = {})
      self.class.live_migrate(id, host, block_migration, disk_over_commit, opts)
    end

    # @return [Hash]
    def add_security_group(sg_name)
      self.class.add_security_group(id, sg_name)
    end

    # @return [Hash]
    def remove_security_group(sg_name)
      self.class.remove_security_group(id, sg_name)
    end

    # @return [Hash]
    def get_vnc_console
      self.class.get_vnc_console(id)
    end

    # @param id [String]
    # @return [Hash]
    def self.shutoff(id)
      action(id, "os-stop" => nil)
    end

    # @param id [String]
    # @return [Hash]
    def self.reboot(id)
      action(id,"reboot" => { "type" => "HARD" })
    end

    # @param id [String]
    # @param flavor_id [String]
    # @return [Hash]
    def self.resize(id, flavor_id)
      action(id,"resize" => { "flavorRef" => flavor_id })
    end

    # @param id [String]
    # @param host [String]
    # @param block_migration [Boolean]
    # @param disk_over_commit [Boolean]
    # @param opts [Hash]
    # @return [Hash]
    def self.live_migrate(id, host = nil, block_migration = false, disk_over_commit = false, opts ={})
      query = {
        "host" => host,
        "block_migration" => block_migration,
        "disk_over_commit" => disk_over_commit,
      }.merge(opts)
      action(id, "os-migrateLive" => query)
    end

    # @param id [String]
    # @param sg_name [String]
    # @return [Hash]
    def self.add_security_group(id, sg_name)
      action(id, {"addSecurityGroup": {"name": sg_name}})
    end

    # @param id [String]
    # @param sg_name [String]
    # @return [Hash]
    def self.remove_security_group(id, sg_name)
      action(id, {"removeSecurityGroup": {"name": sg_name}})
    end

    # @param id [String]
    # @return [String]
    def self.get_vnc_console(id)
      response = action(id, {"os-getVNCConsole": {"type": "novnc"}})
      response.dig("console", "url")
    end

    class << self
      alias :stop :shutoff
    end

    extend MetadataAvailable
    extend Action
  end
end
