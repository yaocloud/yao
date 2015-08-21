module Oslo
  module Resources
    autoload :RestfulResources, "oslo/resources/restful_resources"

    autoload :Server,           "oslo/resources/server"
    autoload :Flavor,           "oslo/resources/flavor"
    autoload :Image,            "oslo/resources/image"
  end
end
