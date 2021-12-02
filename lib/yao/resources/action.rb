module Yao::Resources
  module Action

    # @param id [String]
    # @param query [Hash]
    # @return [Hash]
    def action(id, query)
      res = POST(action_path(id)) do |req|
        req.body = query.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      res.body
    end

    private

    # @param id [String]
    # @return [String]
    def action_path(id)
      [resources_name, id, "action"].join("/")
    end
  end
end
