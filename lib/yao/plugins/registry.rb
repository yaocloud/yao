require 'singleton'

# Regstiry Pattern - https://www.martinfowler.com/eaaCatalog/registry.html
# A well-known object that other objects can use to find common objects and services.
module Yao::Plugins
  class Registry
    include Singleton

    def initialize
      @types = {}
    end

    def [](type)
      @types[type]
    end

    def register(klass, type: nil, name: :default)
      raise("Plugin registration requires both type and name.") if !type or !name
      @types[type] ||= {}
      @types[type][name] = klass
    end
  end

  def self.register(*a)
    Registry.instance.register(*a)
  end
end
