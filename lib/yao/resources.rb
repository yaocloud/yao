module Yao
  module Resources
    require "yao/resources/base"
    require "yao/resources/tenant_associationable"
    require "yao/resources/port_associationable"
    require "yao/resources/network_associationable"

    autoload :Server,                    "yao/resources/server"
    autoload :Flavor,                    "yao/resources/flavor"
    autoload :Image,                     "yao/resources/image"
    autoload :SecurityGroup,             "yao/resources/security_group"
    autoload :SecurityGroupRule,         "yao/resources/security_group_rule"
    autoload :Hypervisor,                "yao/resources/hypervisor"
    autoload :Aggregates,                "yao/resources/aggregates"
    autoload :Keypair,                   "yao/resources/keypair"
    autoload :FloatingIP,                "yao/resources/floating_ip"
    autoload :Network,                   "yao/resources/network"
    autoload :Subnet,                    "yao/resources/subnet"
    autoload :Port,                      "yao/resources/port"
    autoload :Router,                    "yao/resources/router"
    autoload :LoadBalancer,              "yao/resources/loadbalancer"
    autoload :LoadBalancerListener,      "yao/resources/loadbalancer_listener"
    autoload :LoadBalancerPool,          "yao/resources/loadbalancer_pool"
    autoload :LoadBalancerPoolMember,    "yao/resources/loadbalancer_pool_member"
    autoload :LoadBalancerHealthMonitor, "yao/resources/loadbalancer_healthmonitor"
    autoload :Tenant,                    "yao/resources/tenant"
    autoload :Host,                      "yao/resources/host"
    autoload :User,                      "yao/resources/user"
    autoload :Role,                      "yao/resources/role"
    autoload :RoleAssignment,            "yao/resources/role_assignment"
    autoload :Volume,                    "yao/resources/volume"
    autoload :VolumeType,                "yao/resources/volume_type"
    autoload :ComputeServices,           "yao/resources/compute_services"
    autoload :Project,                   "yao/resources/project"

    autoload :Resource,                  "yao/resources/resource"
    autoload :Meter,                     "yao/resources/meter"
    autoload :OldSample,                 "yao/resources/old_sample"
    autoload :Sample,                    "yao/resources/sample"
  end

  def self.const_missing(name)
    new_klass = Yao::Resources.const_get(name)
    Yao.const_set(name, new_klass)
  rescue NameError
    super
  end
end
