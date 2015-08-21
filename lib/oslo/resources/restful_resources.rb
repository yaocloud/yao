require "forwardable"

module Oslo::Resources
  class RestfulResources
    class << self
      attr_reader   :client
      attr_accessor :resource_name, :resources_name

      extend Forwardable
      %w(get post put delete).each do |method_name|
          def_delegator :client, method_name, method_name.upcase
      end

      def service=(name)
        @client ||= Oslo.default_client.pool[name]
      end

      def list
        GET(resources_name).body[resources_name]
      end

      def list_detail
        GET([resources_name, "detail"].join("/")).body[resources_name]
      end

      def get(id_or_permalink)
        res = if id_or_permalink =~ /^https?:\/\//
                GET(id_or_permalink)
              else
                GET([resources_name, id_or_permalink].join("/"))
              end
        res.body[resource_name]
      end
    end
  end
end
