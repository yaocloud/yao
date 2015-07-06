require 'oslo'

module Oslo
  class Config
    def _configuration_defaults
      @_configuration_defaults ||= {}
    end

    def _configuration_hooks
      @_configuration_hooks ||= {}
    end

    def configuration
      @configuration ||= {}
    end

    def param(name, default, &hook)
      raise("Duplicate definition of #{name}") if self.respond_to?(name)

      name = name.to_sym
      _configuration_defaults[name] = default
      _configuration_hooks[name] = hook if block_given?
      self.define_singleton_method(name) do
        configuration[name] || _configuration_defaults[name]
      end
    end

    def set(name, value)
      raise("Undefined config key #{name}") unless self.respond_to?(name)
      configuration[name.to_sym] = value
      _configuration_hooks[name].call(value) if _configuration_hooks[name]
      value
    end
  end

  def self.config
    @__config ||= Config.new
  end
end
