require "forwardable"

module Oslo::Resources
  class RestfulResources
    class << self
      attr_reader   :client
      attr_accessor :resource_name, :resources_name

      extend Forwardable
      def_delegators :client, *%i(get post put delete)

      def client=(name)
        @client ||= Oslo.default_client.pool[name]
      end

      def list
        get(resources_name).body[resources_name]
      end

      def list_detail
        get([resources_name, "detail"].join("/")).body[resources_name]
      end

      def get(id_or_permalink)
        res = if id_or_permalink =~ /^https?:\/\//
                get(id_or_permalink)
              else
                get([resources_name, id_or_permalink].join("/"))
              end
        res.body[resource_name]
      end
    end
  end
end
