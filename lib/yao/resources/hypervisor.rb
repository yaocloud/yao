require 'ostruct'

module Yao::Resources
  class Hypervisor < Base
    friendly_attributes :hypervisor_hostname, :hypervisor_type, :hypervisor_version, :running_vms, :current_workload,
                        :vcpus, :vcpus_used,
                        :memory_mb, :memory_mb_used, :free_disk_gb,
                        :local_gb, :local_gb_used, :free_disk_gb, :status

    # @return [Hash]
    def cpu_info
      JSON.parse self["cpu_info"]
    end

    # @return [Bool]
    def enabled?
      self['status'] == 'enabled'
    end

    # @return [Bool]
    def disabled?
      self['status'] == 'disabled'
    end

    # @return [Yao::Resources::ComputeServices]
    def service
      Yao::ComputeServices.new(self['service'])
    end

    alias hostname hypervisor_hostname
    alias type     hypervisor_type
    alias version  hypervisor_version

    self.service        = "compute"
    self.resource_name  = "os-hypervisor"
    self.resources_name = "os-hypervisors"
    self.resources_detail_available = true

    class << self
      # @return [Yao::Resources::Hypervisor::Statistics]
      def statistics
        json = GET([resources_path, "statistics"].join("/")).body
        Yao::Resources::Hypervisor::Statistics.new(json["hypervisor_statistics"])
      end

      # @param id [String]
      # @return [Yao::Resources::Hypervisor::Uptime]
      def uptime(id)
        json = GET([resources_path, id, "uptime"].join("/")).body
        Yao::Resources::Hypervisor::Uptime.new(json["hypervisor"])
      end
    end

    class Statistics < OpenStruct; end
    class Uptime     < OpenStruct; end
  end
end
