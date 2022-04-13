require "forwardable"
require "deep_merge"
module Yao::Resources
  module RestfullyAccessible
    def self.extended(base)
      base.class_eval do
        class << self
          attr_accessor :resource_name, :resources_name, :resources_detail_available

          extend Forwardable
          %w(get post put delete).each do |method_name|
            def_delegator :client, method_name, method_name.upcase
          end
        end
      end
    end

    # @param name [String]
    # @return
    def service=(name)
      @service = name
    end
    attr_reader :service

    # @return [String]
    def api_version
      @api_version || ''
    end

    # @param v [String]
    # @return [String]
    def api_version=(v)
      raise("Set api_version after service is declared") unless service
      @api_version = v
      api_version
    end

    # @param bool [Boolean]
    # @return [Boolean]
    def admin=(bool)
      @admin = bool
    end

    # @return [Boolean]
    def return_single_on_querying
      @return_single_on_querying
    end

    # @param bool [Boolean]
    # @return [Boolean]
    def return_single_on_querying=(bool)
      @return_single_on_querying = bool
    end

    # @return [String]
    def resources_path
      @resources_path || resources_name
    end

    # @param path [String]
    # @return [String]
    def resources_path=(path)
      @resources_path = path.sub(%r!^\/!, "")
    end

    # @return [Faraday::Connection]
    def client
      if @admin
        Yao.default_client.admin_pool[service]
      else
        Yao.default_client.pool[service]
      end or raise "You do not have #{@admin ? 'admin' : 'public'} access to the #{service} service"
    end

    # @param blk [Proc]
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

    # @param query [Hash]
    # @return [Yao::Resources::*]
    # @return [Array<Yao::Resources::*]
    def list(query={})

      url = if resources_detail_available
        # If the resource has 'detail', #list tries to GET /${resourece}/detail
        # For example.
        #
        #   GET /servers/detail
        #   GET /flavors/detail
        #
        create_url('detail')
      else
        create_url
      end
      memo_query = query
      res = {}
      loop do
        r = GET(url, query).body
        if r.is_a?(Hash)
          res.deep_merge!(r)
          links = r.find {|k,_| k =~ /links/ }
          if links && links.last.is_a?(Array) && next_link = links.last.find{|s| s["rel"] == "next" }
            uri = URI.parse(next_link["href"])
            query = Hash[URI::decode_www_form(uri.query)] if uri.query
            next
          end
        else
          res = r
        end
        break
      end
      if return_single_on_querying && !query.empty?
        [resource_from_json(res)]
      else
        resources_from_json(res)
      end
    end

    # @note .list is defined to keep backward compatibility and will be deprecated
    alias :list_detail :list

    # @param id_or_name_or_permalink [Stirng]
    # @param query [Hash]
    # @return [Yao::Resources::*]
    def get(id_or_name_or_permalink, query={})
      res = if id_or_name_or_permalink.start_with?("http://", "https://")
              GET(id_or_name_or_permalink, query)
            elsif uuid?(id_or_name_or_permalink)
              GET(create_url(id_or_name_or_permalink), query)
            else
              get_by_name(id_or_name_or_permalink, query)
            end

      resource_from_json(res.body)
    end
    alias find get

    # @param id_or_name_or_permalink [Stirng]
    # @param query [Hash]
    # @return [Yao::Resources::*]
    def get!(id_or_name_or_permalink, query={})
      get(id_or_name_or_permalink, query)
    rescue Yao::ItemNotFound, Yao::NotFound, Yao::InvalidResponse
      nil
    end

    def find_by_name(name, query={})
      list(query.merge({"name" => name}))
    end

    # @param resource_params [Hash]
    # @return [Yao::Resources::*]
    def create(resource_params)
      params = {
        resource_name_in_json => resource_params
      }
      res = POST(create_url) do |req|
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      resource_from_json(res.body)
    end

    # @param id [String]
    # @return [Yao::Resources::*]
    def update(id, resource_params)
      params = {
        resource_name_in_json => resource_params
      }
      res = PUT(create_url(id)) do |req|
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      resource_from_json(res.body)
    end

    # @param id [String]
    # @return [String]
    def destroy(id)
      res = DELETE(create_url(id))
      res.body
    end
    alias delete destroy

    private

    # returns pathname of resource URL
    # @param subpath [String]
    # @return [String]
    def create_url(subpath='')
      paths = [ api_version, resources_path, subpath ]
      paths.select{|s| s != ''}.join('/')
    end

    # @return [String]
    def resource_name_in_json
      @_resource_name_in_json ||= resource_name.sub(/^os-/, "").tr("-", "_")
    end

    # @return [String]
    def resources_name_in_json
      @resources_name_in_json ||= resources_name.sub(/^os-/, "").tr("-", "_")
    end

    # @param json [Hash]
    # @return [Yao::Resources::*]
    def resource_from_json(json)
      attribute = json[resource_name_in_json]
      new(attribute)
    end

    # @param json [Hash]
    # @return [Array<Yao::Resources::*>]
    def resources_from_json(json)
      json[resources_name_in_json].map { |attribute|
        new(attribute) # instance of Yao::Resources::*
      }
    end

    def uuid?(str)
      /^[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}$/ === str
    end

    # At first, search by ID. If nothing is found, search by name.
    # @param name [String]
    # @param query [Hash]
    # @return [Yao::Resources::*]
    def get_by_name(name, query={})

      begin
        GET(create_url(name), query)
      rescue => e
        raise e unless e.class == Yao::ItemNotFound || e.class == Yao::NotFound
        item = find_by_name(name).select { |r| r.name == name }
        if item.size > 1
          raise Yao::TooManyItemFonud.new("More than one resource exists with the name '#{name}'")
        elsif item.size.zero?
          raise Yao::InvalidResponse.new("No resource exists with the name '#{name}'")
        end
        GET(create_url(item.first.id), query)
      end
    end
  end
end
