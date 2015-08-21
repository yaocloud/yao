module Oslo
  module Resources
    autoload :RestfulResources, "oslo/resources/restful_resources"

    autoload :Server,           "oslo/resources/server"
    autoload :Flavor,           "oslo/resources/flavor"
    autoload :Image,            "oslo/resources/image"
  end

  def self.const_missing(name)
    new_klass = Oslo::Resources.const_get(name)
    Oslo.const_set(name, new_klass)
  rescue NameError
    super
  end
end
