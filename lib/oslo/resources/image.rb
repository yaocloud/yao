module Oslo::Resources
  class Image < Base
    self.service        = "compute"
    self.resource_name  = "image"
    self.resources_name = "images"
  end
end
