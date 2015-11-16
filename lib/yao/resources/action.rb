module Yao::Resources
  module Action
    def action(id, query)
      res = POST(action_path(id)) do |req|
        req.body = query.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      return_resource(resource_from_json(res.body))
    end

    private
    def action_path(id)
      [resources_name, id, "action"].join("/")
    end
  end
end
