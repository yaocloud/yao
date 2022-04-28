require 'yao/resources/restfully_accessible'
require 'time'

module Yao::Resources
  class Base

    # @param name [String]
    def self.add_instantiation_name_list(name)
      @instantiation_list ||= []
      @instantiation_list << name
    end

    # @param name [String]
    # @return [bool]
    def self.instantiation?(name)
      @instantiation_list.include?(name)
    end

    # @param name [Array]
    def self.friendly_attributes(*names)
      names.map(&:to_s).each do |name|
        add_instantiation_name_list(name)
        define_method(name) do
          self[name]
        end
      end
    end

    # @param k_and_v [Hash]
    # @return [Symbol]
    def self.map_attribute_to_attribute(k_and_v)
      as_json, as_method = *k_and_v.to_a.first.map(&:to_s)
      add_instantiation_name_list(as_method)
      define_method(as_method) do
        self[as_json]
      end
    end

    # @param k_and_v [Hash]
    # @return [Symbol]
    def self.map_attribute_to_resource(k_and_v)
      _name, klass = *k_and_v.to_a.first
      name = _name.to_s
      add_instantiation_name_list(name)
      define_method(name) do
        unless self[name].empty?
          self[[name, klass].join("__")] ||= klass.new(self[name])
        end
      end
    end

    # @param k_and_v [Hash]
    # @return [Symbol]
    def self.map_attribute_to_resources(k_and_v)
      _name, klass = *k_and_v.to_a.first
      name = _name.to_s
      add_instantiation_name_list(name)
      define_method(name) do
        self[[name, klass].join("__")] ||= self[name].map {|d|
          klass.new(d)
        }
      end
    end

    # @param names [Array<Symbol>]
    # @return [Symbol]
    def self.map_attributes_to_time(*names)
      names.map(&:to_s).each do |name|
        add_instantiation_name_list(name)
        define_method(name) do
          Time.parse(self[name])
        end
      end
    end

    # @param data_via_json [Hash]
    # @return [Hash]
    def initialize(data_via_json)
      @data = data_via_json
    end

    # @param name [String]
    # @return [String]
    def [](name)
      if @data["id"] && !@data.key?(name) && self.class.instantiation?(name)
        @data = self.class.get(@data["id"]).to_hash
      end
      @data[name]
    end

    # @param name [String]
    # @param value [String]
    # @return [String]
    def []=(name, value)
      @data[name] = value
    end

    # @return [Hash]
    def to_hash
      @data
    end

    # @return [String]
    def id
      self["id"]
    end

    # @param resource_params [Hash]
    # @return [Yao::Resources::*]
    def update(resource_params)
      self.class.update(id, resource_params)
    end

    # @return [String]
    def destroy
      self.class.destroy(id)
    end
    alias delete destroy

    extend RestfullyAccessible
  end
end
