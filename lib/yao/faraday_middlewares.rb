require 'faraday'

class Faraday::Request::OSToken
  def initialize(app, token)
    @app = app
    @token = token
  end

  def call(env)
    env[:request_headers]['X-Auth-Token'] = @token
    @app.call(env)
  end
end
Faraday::Request.register_middleware os_token: -> { Faraday::Request::OSToken }
