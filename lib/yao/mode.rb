module Yao
  module Mode
    def read_only!(&blk)
      raise unless block_given?

      raise_on_write_org = Yao.config.raise_on_write
      noop_on_write_org  = Yao.config.noop_on_write

      Yao.config.set :noop_on_write, false if noop_on_write_org
      Yao.config.set :raise_on_write, true
      begin
        yield
      ensure
        Yao.config.set :raise_on_write, raise_on_write_org
        Yao.config.set :noop_on_write,  noop_on_write_org
      end
    end

    def read_only(&blk)
      raise unless block_given?

      noop_on_write_org  = Yao.config.noop_on_write
      raise_on_write_org = Yao.config.raise_on_write

      Yao.config.set :raise_on_write, false if raise_on_write_org
      Yao.config.set :noop_on_write, true
      begin
        yield
      ensure
        Yao.config.set :noop_on_write,  noop_on_write_org
        Yao.config.set :raise_on_write, raise_on_write_org
      end
    end
  end
end
