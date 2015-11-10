module Yao
  module Resources
    require "yao/resources/base"

    autoload :Server,            "yao/resources/server"
    autoload :Flavor,            "yao/resources/flavor"
    autoload :Image,             "yao/resources/image"
    autoload :SecurityGroup,     "yao/resources/security_group"
    autoload :SecurityGroupRule, "yao/resources/security_group_rule"
    autoload :Hypervisor,        "yao/resources/hypervisor"
    autoload :Keypair,           "yao/resources/keypair"
    autoload :FloatingIP,        "yao/resources/floating_ip"
    autoload :Network,           "yao/resources/network"
    autoload :Subnet,            "yao/resources/subnet"
    autoload :Port,              "yao/resources/port"
    autoload :Tenant,            "yao/resources/tenant"
    autoload :Host,              "yao/resources/host"
    autoload :User,              "yao/resources/user"
    autoload :Role,              "yao/resources/role"

    autoload :Resource,          "yao/resources/resource"
  end

  def self.const_missing(name)
    new_klass = Yao::Resources.const_get(name)
    Yao.const_set(name, new_klass)
  rescue NameError
    super
  end
end
