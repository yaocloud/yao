module Yao
  class Config
    def _configuration_defaults
      @_configuration_defaults ||= {}
    end

    def _configuration_hooks
      @_configuration_hooks ||= {}
    end

    def _configuration_hooks_queue
      @_configuration_hooks_queue ||= []
    end

    def configuration
      @configuration ||= {}
    end

    HOOK_RENEW_CLIENT_KEYS = %i(tenant_name username password auth_url debug debug_record_response)
    def delay_hook=(v)
      @delay_hook = v
      if !v and !_configuration_hooks_queue.empty?
        _configuration_hooks_queue.each do |n, val|
          _configuration_hooks[n].call(val) if _configuration_hooks[n]
        end
        # Authorization process should have special hook
        # and should run last
        unless (_configuration_hooks_queue.map(&:first) & HOOK_RENEW_CLIENT_KEYS).empty?
          Yao::Auth.try_new
        end

        _configuration_hooks_queue.clear
      end
    end

    def delay_hook?
      @delay_hook
    end

    def param(name, default, &hook)
      raise("Duplicate definition of #{name}") if self.respond_to?(name)

      name = name.to_sym
      _configuration_defaults[name] = default
      _configuration_hooks[name] = hook if block_given?
      self.define_singleton_method(name) do |*a|
        case a.size
        when 0
          configuration[name] || _configuration_defaults[name]
        when 1
          set(name, a.first)
        else
          raise ArgumentError, "wrong number of arguments (#{a.size} for 0, 1)"
        end
      end
    end

    def set(name, value)
      raise("Undefined config key #{name}") unless self.respond_to?(name)
      configuration[name.to_sym] = value
      if delay_hook?
        _configuration_hooks_queue.push([name, value])
      else
        _configuration_hooks[name].call(value) if _configuration_hooks[name]
      end
      value
    end
  end

  def self.config(&blk)
    @__config ||= Config.new
    if blk
      @__config.delay_hook = true
      @__config.instance_eval(&blk)
      @__config.delay_hook = false
    end
    @__config
  end

  def self.configure(&blk)
    config(&blk)
  end
end
