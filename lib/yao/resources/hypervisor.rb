module Yao::Resources
  class Hypervisor < Base
    friendly_attributes :hypervisor_hostname, :hypervisor_type, :hypervisor_version, :running_vms, :current_workload,
                        :vcpus, :vcpus_used,
                        :memory_mb, :memory_mb_used, :free_disk_gb,
                        :local_gb, :local_gb_used, :free_disk_gb

    def cpu_info
      JSON.parse self["cpu_info"]
    end

    alias hostname hypervisor_hostname
    alias type     hypervisor_hostname
    alias version  hypervisor_version

    self.service        = "compute"
    self.resource_name  = "os-hypervisor"
    self.resources_name = "os-hypervisors"
  end
end
