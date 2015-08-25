require 'oslo/resources/security_group_rule'
module Oslo::Resources
  class SecurityGroup < Base
    friendly_attributes :name, :description, :tenant_id

    def rules
      self[["rules", SecurityGroupRule].join("__")] ||= (case self.class.service
      when "compute"
        self["rules"].map{|r| SecurityGroupRule.new(r) }
      when "network"
        self["security_group_rules"].map{|r| SecurityGroupRule.new(r) }
      end)
    end

    self.service        = "compute"
    self.resource_name  = "os-security-group"
    self.resources_name = "os-security-groups"
  end
end

Oslo.config.param :security_group_service, "compute" do |service|
  case service
  when "compute"
    Oslo::Resources::SecurityGroup.service        = service
    Oslo::Resources::SecurityGroup.resource_name  = "os-security-group"
    Oslo::Resources::SecurityGroup.resources_name = "os-security-groups"

    Oslo::Resources::SecurityGroupRule.service        = service
    Oslo::Resources::SecurityGroupRule.resource_name  = "os-security-group-rule"
    Oslo::Resources::SecurityGroupRule.resources_name = "os-security-group-rules"
  when "network"
    Oslo::Resources::SecurityGroup.service        = service
    Oslo::Resources::SecurityGroup.resource_name  = "security-group"
    Oslo::Resources::SecurityGroup.resources_name = "security-groups"

    Oslo::Resources::SecurityGroupRule.service        = service
    Oslo::Resources::SecurityGroupRule.resource_name  = "security-group-rule"
    Oslo::Resources::SecurityGroupRule.resources_name = "security-group-rules"
  end
end
