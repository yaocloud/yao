require 'singleton'

# Regstiry Pattern - https://www.martinfowler.com/eaaCatalog/registry.html
# A well-known object that other objects can use to find common objects and services.
module Yao::Plugins
  class Registry
    include Singleton

    def initialize
      @types = {}
    end

    # @param type [Symbol]
    # @return [Object]
    def [](type)
      @types[type]
    end

    # @param klass [*]
    # @param type [Symbol]
    # @param name [Symbol]
    def register(klass, type: nil, name: :default)
      raise("Plugin registration requires both type and name.") if !type or !name
      @types[type] ||= {}
      @types[type][name] = klass
    end
  end

  # @param [*]
  # @param [Symbol]
  # @param [Symbol]
  def self.register(klass, **kw)
    Registry.instance.register(klass, **kw)
  end
end
