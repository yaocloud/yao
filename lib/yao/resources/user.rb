module Yao::Resources
  class User < Base
    friendly_attributes :name, :email, :enabled, :id

    alias enabled? enabled

    self.service        = "identity"
    self.resource_name  = "user"
    self.resources_name = "users"
    self.admin          = true
  end
end
