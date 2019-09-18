module Yao
  class APIVersions

    attr_reader :stable, :deprecated

    # @param [Array<Yao::APIVersion>]
    def initialize(versions)
      @stable     = versions.find(&:stable?)
      @deprecated = versions.find(&:deprecated?)
    end
  end

  class APIVersion

    attr_reader :status, :updated, :mediya_types, :id, :links

    def initialize(params)
      @status      = params["status"]
      @updated     = params["updated"]
      @media_types = params["media-types"]
      @id          = params["id"]
      @links       = params["links"]

      @min_version = params["min_version"]
      @version     = params["version"]
    end

    # @return [Bool]
    def stable?
      status == 'stable'
    end

    # @return [Bool]
    def supported?
      status == 'SUPPORTED'
    end

    # @return [Bool]
    def deprecated?
      status == 'deprecated'
    end

    # @return [Bool]
    def v2?
      !!id.match(/^v2/)
    end

    # @return [Bool]
    def v3?
      !!id.match(/^v3/)
    end
  end
end
