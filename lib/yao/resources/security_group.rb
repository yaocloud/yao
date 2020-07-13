require 'yao/resources/security_group_rule'
module Yao::Resources
  class SecurityGroup < Base
    include TenantAssociationable

    friendly_attributes :name, :description

    # @return [Array<Yao::Resources::SecurityGroupRule>]
    def rules
      self[["rules", SecurityGroupRule].join("__")] ||= (case self.class.service
      when "compute"
        self["rules"].map{|r| SecurityGroupRule.new(r) }
      when "network"
        self["security_group_rules"].map{|r| SecurityGroupRule.new(r) }
      end)
    end

    self.service        = "network"
    self.resource_name  = "security-group"
    self.resources_name = "security-groups"
  end
end

Yao.config.param :security_group_service, "compute" do |service|
  case service
  when "compute"
    Yao::Resources::SecurityGroup.service        = service
    Yao::Resources::SecurityGroup.resource_name  = "os-security-group"
    Yao::Resources::SecurityGroup.resources_name = "os-security-groups"

    Yao::Resources::SecurityGroupRule.service        = service
    Yao::Resources::SecurityGroupRule.resource_name  = "os-security-group-rule"
    Yao::Resources::SecurityGroupRule.resources_name = "os-security-group-rules"
  when "network"
    Yao::Resources::SecurityGroup.service        = service
    Yao::Resources::SecurityGroup.resource_name  = "security-group"
    Yao::Resources::SecurityGroup.resources_name = "security-groups"

    Yao::Resources::SecurityGroupRule.service        = service
    Yao::Resources::SecurityGroupRule.resource_name  = "security-group-rule"
    Yao::Resources::SecurityGroupRule.resources_name = "security-group-rules"
  end
end
