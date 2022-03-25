require 'yao/resources/restfully_accessible'
require 'time'

module Yao::Resources
  class Base

    # @param name [Array]
    def self.friendly_attributes(*names)
      names.map(&:to_s).each do |name|
        define_method(name) do
          self[name]
        end
      end
    end

    # @param k_and_v [Hash]
    # @return [Symbol]
    def self.map_attribute_to_attribute(k_and_v)
      as_json, as_method = *k_and_v.to_a.first.map(&:to_s)
      define_method(as_method) do
        self[as_json]
      end
    end

    # @param k_and_v [Hash]
    # @return [Symbol]
    def self.map_attribute_to_resource(k_and_v)
      _name, klass = *k_and_v.to_a.first
      name = _name.to_s
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
      define_method(name) do
        self[[name, klass].join("__")] ||= self[name].map {|d|
          klass.new(d)
        }
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
      unless @data["id"].nil? || @data.key?(name) || name.include?("__")
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

    # @return [Date]
    def created
      if date = self["created_at"] || self["created"]
        Time.parse(date)
      end
    end

    # @return [Date]
    def updated
      if date = self["updated_at"] || self["updated"]
        Time.parse(date)
      end
    end

    extend RestfullyAccessible
  end
end
