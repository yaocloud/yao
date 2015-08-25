module Oslo::Resources
  class SecurityGroup < Base
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
  when "network"
    Oslo::Resources::SecurityGroup.service        = service
    Oslo::Resources::SecurityGroup.resource_name  = "security-group"
    Oslo::Resources::SecurityGroup.resources_name = "security-groups"
  end
end
