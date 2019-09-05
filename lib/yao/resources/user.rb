module Yao::Resources
  class User < Base
    friendly_attributes :name, :email, :enabled, :id

    alias enabled? enabled

    self.service        = "identity"
    self.resource_name  = "user"
    self.resources_name = "users"
    self.admin          = true

    if self.client.url_prefix.to_s.match?(/v2\.0/)
      self.return_single_on_querying = true
    end

    class << self
      def find_by_name(name, query={})
        if client.url_prefix.to_s.match?(/v2\.0/)
          [super]
        else
          super
        end
      end
    end
  end
end
