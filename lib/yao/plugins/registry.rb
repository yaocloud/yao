require 'singleton'

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

    def self.register(*a)
      instance.register(*a)
    end
  end
end
