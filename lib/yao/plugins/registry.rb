require 'singleton'

module Yao::Plugins
  class Registry
    include Singleton

    def initialize
      @types = {}
      @types[:client_generator] = {}
    end

    def [](type)
      @types[type]
    end
  end
end
