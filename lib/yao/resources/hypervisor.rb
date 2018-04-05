require 'ostruct'

module Yao::Resources
  class Hypervisor < Base
    friendly_attributes :hypervisor_hostname, :hypervisor_type, :hypervisor_version, :running_vms, :current_workload,
                        :vcpus, :vcpus_used,
                        :memory_mb, :memory_mb_used, :free_disk_gb,
                        :local_gb, :local_gb_used, :free_disk_gb, :status

    def cpu_info
      JSON.parse self["cpu_info"]
    end

    def enabled?
      self['status'] == 'enabled'
    end

    alias hostname hypervisor_hostname
    alias type     hypervisor_hostname
    alias version  hypervisor_version

    self.service        = "compute"
    self.resource_name  = "os-hypervisor"
    self.resources_name = "os-hypervisors"

    class << self
      def list_detail(query={})
        return_resources(
          resources_from_json(
            GET([resources_path, "detail"].join("/"), query).body
          )
        )
      end

      def statistics
        json = GET([resources_path, "statistics"].join("/")).body
        Yao::Resources::Hypervisor::Statistics.new(json["hypervisor_statistics"])
      end

      def uptime(id)
        res = resource_from_json(
                GET([resources_path, id, "uptime"].join("/")).body
              )
        Yao::Resources::Hypervisor::Uptime.new(res)
      end
    end

    class Statistics < OpenStruct; end
    class Uptime     < OpenStruct; end
  end
end
