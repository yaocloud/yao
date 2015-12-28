module Yao
  module Mode
    def read_only!(&blk)
      raise unless block_given?

      Yao.config.set :raise_on_write, true
      yield
      Yao.config.set :raise_on_write, false
    end

    def read_only(&blk)
      raise unless block_given?

      Yao.config.set :noop_on_write, true
      yield
      Yao.config.set :noop_on_write, false
    end
  end
end
