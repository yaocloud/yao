require "forwardable"

module Yao::Resources
  module RestfullyAccessible
    def self.extended(base)
      base.class_eval do
        class << self
          attr_reader   :client
          attr_accessor :resource_name, :resources_name

          extend Forwardable
          %w(get post put delete).each do |method_name|
            def_delegator :client, method_name, method_name.upcase
          end
        end
      end
    end

    def service=(name)
      @service = name
      @client = Yao.default_client.pool[name]
    end

    def service
      @service
    end

    # restful methods
    def list
      return_resources(GET(resources_name).body[resources_name_in_json])
    end

    def list_detail
      return_resources(GET([resources_name, "detail"].join("/")).body[resources_name_in_json])
    end

    def get(id_or_permalink)
      res = if id_or_permalink =~ /^https?:\/\//
              GET(id_or_permalink)
            else
              GET([resources_name, id_or_permalink].join("/"))
            end
      return_resource(res.body[resource_name_in_json])
    end
    alias find get

    def create(resource_params)
      params = {
        resource_name_in_json => resource_params
      }
      res = POST(resources_name) do |req|
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      return_resource(res.body[resource_name_in_json])
    end

    def update(id, resource_params)
      params = {
        resource_name_in_json => resource_params
      }
      res = PUT([resources_name, id].join("/")) do |req|
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      return_resource(res.body[resource_name_in_json])
    end

    def destroy(id)
      res = DELETE([resources_name, id].join("/"))
      res.body
    end

    private
    def resource_name_in_json
      @resource_name_in_json  ||= resource_name.sub(/^os-/, "").tr("-", "_")
    end

    def resources_name_in_json
      @resources_name_in_json ||= resources_name.sub(/^os-/, "").tr("-", "_")
    end

    def return_resource(d)
      new(d)
    end

    def return_resources(arr)
      arr.map{|d| return_resource(d) }
    end
  end
end
