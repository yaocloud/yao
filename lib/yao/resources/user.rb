module Yao::Resources
  class User < Base
    friendly_attributes :name, :email, :enabled, :id

    alias enabled? enabled

    self.service        = "identity"
    self.resource_name  = "user"
    self.resources_name = "users"
    self.admin          = true

    class << self
      def get_by_name(name)
        self.get("", name: name)
      end
      alias find_by_name get_by_name
    end
  end
end
