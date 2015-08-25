module Oslo
  module Resources
    require "oslo/resources/base"

    autoload :Server,            "oslo/resources/server"
    autoload :Flavor,            "oslo/resources/flavor"
    autoload :Image,             "oslo/resources/image"
    autoload :SecurityGroup,     "oslo/resources/security_group"
    autoload :SecurityGroupRule, "oslo/resources/security_group_rule"
    autoload :Hypervisor,        "oslo/resources/hypervisor"
    autoload :Keypair,           "oslo/resources/keypair"
    autoload :FloatingIP,        "oslo/resources/floating_ip"
    autoload :Network,           "oslo/resources/network"
    autoload :Subnet,            "oslo/resources/subnet"
    autoload :Port,              "oslo/resources/port"

  end

  def self.const_missing(name)
    new_klass = Oslo::Resources.const_get(name)
    Oslo.const_set(name, new_klass)
  rescue NameError
    super
  end
end
