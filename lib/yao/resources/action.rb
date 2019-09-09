module Yao::Resources
  module Action
    def action(id, query)
      res = POST(action_path(id)) do |req|
        req.body = query.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      res.body ? resource_from_json(res.body) : nil
    end

    private
    def action_path(id)
      [resources_name, id, "action"].join("/")
    end
  end
end
