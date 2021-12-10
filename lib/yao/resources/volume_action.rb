require 'yao/resources/action'

module Yao::Resources
  module VolumeAction
    include Action

    def set_status(id, status)
      action(id, 'os-reset_status' => {
        'status' => status,
      })
    end
  end
end
