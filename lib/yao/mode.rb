module Yao
  module Mode
    def read_only!(&blk)
      raise unless block_given?

      Yao.config.set :raise_on_write, true
      begin
        yield
      ensure
        Yao.config.set :raise_on_write, false
      end
    end

    def read_only(&blk)
      raise unless block_given?

      Yao.config.set :noop_on_write, true
      begin
        yield
      ensure
        Yao.config.set :noop_on_write, false
      end
    end
  end
end
