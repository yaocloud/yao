require 'oslo/resources/restfully_accessible'
module Oslo::Resources
  class Base
    def self.friendly_attributes(*names)
      names.map(&:to_s).each do |name|
        define_method(name) do
          self[name]
        end
      end
    end

    def initialize(data_via_json)
      @data = data_via_json
    end

    def [](name)
      @data[name]
    end

    extend RestfullyAccessible
  end
end
