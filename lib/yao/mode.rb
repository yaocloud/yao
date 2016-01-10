module Yao
  module Mode
    def read_only!(&blk)
      raise unless block_given?

      before = Yao.config.raise_on_write

      Yao.config.set :raise_on_write, true
      begin
        yield
      ensure
        Yao.config.set :raise_on_write, before
      end
    end

    def read_only(&blk)
      raise unless block_given?

      before = Yao.config.noop_on_write

      Yao.config.set :noop_on_write, true
      begin
        yield
      ensure
        Yao.config.set :noop_on_write, before
      end
    end
  end
end
