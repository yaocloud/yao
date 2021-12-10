module Yao::Resources
  class User < Base
    friendly_attributes :name, :email, :enabled

    alias enabled? enabled

    self.service        = "identity"
    self.resource_name  = "user"
    self.resources_name = "users"
    self.admin          = true

    # @return [Yao::Resources::RoleAssignment]
    def role_assignment
      Yao::RoleAssignment.get(user: self)
    end

    class << self
      # @return [Bool]
      def return_single_on_querying
        api_verion_v2?
      end

      private
      # @return [Bool]
      def api_verion_v2?
        client.url_prefix.to_s.match?(/v2\.0/)
      end
    end
  end
end
