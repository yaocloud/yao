require "forwardable"

module Yao::Resources
  module RestfullyAccessible
    def self.extended(base)
      base.class_eval do
        class << self
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
    end
    attr_reader :service

    def api_version
      @api_version || ''
    end

    def api_version=(v)
      raise("Set api_version after service is declared") unless service
      @api_version = v
      api_version
    end

    def admin=(bool)
      @admin = bool
    end

    def return_single_on_querying=(bool)
      @return_single_on_querying = bool
    end

    def resources_path
      @resources_path || resources_name
    end

    def resources_path=(path)
      @resources_path = path.sub(%r!^\/!, "")
    end

    def client
      if @admin
        Yao.default_client.admin_pool[service]
      else
        Yao.default_client.pool[service]
      end or raise "You do not have #{@admin ? 'admin' : 'public'} access to the #{service} service"
    end

    def as_member(&blk)
      if @admin
        @admin = false
        result = yield
        @admin = true
        result
      else
        yield
      end
    end

    def with_resources_path(path, &blk)
      original = @resources_path
      @resources_path = path
      result = yield
      @resources_path = original

      result
    end

    # restful methods
    def list(query={})
      json = GET([api_version, resources_path], query).body
      if @return_single_on_querying && !query.empty?
        return_resource(resource_from_json(json))
      else
        return_resources(resources_from_json(json))
      end
    end

    def get(id_or_name_or_permalink, query={})
      res = if id_or_name_or_permalink.start_with?("http://", "https://")
              GET(api_version, id_or_name_or_permalink, query)
            elsif uuid?(id_or_name_or_permalink)
              GET([api_version, resources_path, id_or_name_or_permalink].join("/"), query)
            else
              get_by_name(id_or_name_or_permalink, query)
            end

      return_resource(resource_from_json(res.body))
    end
    alias find get

    def find_by_name(name, query={})
      list(query.merge({"name" => name}))
    end

    def create(resource_params)
      params = {
        resource_name_in_json => resource_params
      }
      res = POST([api_version, resources_path]) do |req|
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      return_resource(resource_from_json(res.body))
    end

    def update(id, resource_params)
      params = {
        resource_name_in_json => resource_params
      }
      res = PUT([api_version, resources_path, id].join("/")) do |req|
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      return_resource(resource_from_json(res.body))
    end

    def destroy(id)
      res = DELETE([api_version, resources_path, id].join("/"))
      res.body
    end

    private
    def resource_name_in_json
      @_resource_name_in_json ||= resource_name.sub(/^os-/, "").tr("-", "_")
    end

    def resource_from_json(json)
      json[resource_name_in_json]
    end

    def resources_from_json(json)
      @resources_name_in_json ||= resources_name.sub(/^os-/, "").tr("-", "_")
      json[@resources_name_in_json]
    end

    def return_resource(d)
      new(d)
    end

    def return_resources(arr)
      arr.map{|d| return_resource(d) }
    end

    def uuid?(str)
      /^[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}$/ === str
    end

    def get_by_name(name, query={})
      # At first, search by ID. If nothing is found, search by name.
      begin
        GET([api_version, resources_path, name].join("/"), query)
      rescue Yao::ItemNotFound
        item = find_by_name(name)
        if item.size > 1
          raise Yao::TooManyItemFonud.new("More than one resource exists with the name '#{name}'")
        end
        GET([api_version, resources_path, item.first.id].join("/"), query)
      end
    end
  end
end
