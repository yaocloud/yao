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

class Faraday::Request::OSDumper < Faraday::Response::Middleware
  def on_complete(env)
    require 'pp'
    params = [
      env.url.to_s,
      JSON.parse(env.body),
      env.request_headers,
      env.response_headers,
      env.method,
      env.status
    ].map(&:pretty_inspect)
    $stdout.puts(<<-FMT % params)
================================
 OpenStack response inspection:
================================
Requested To: %s

Body:
%s
Request Headers:
%s
Response Headers:
%s

Method: %s
Status Code: %s
================================

    FMT
  end
end
Faraday::Response.register_middleware os_dumper: -> { Faraday::Request::OSDumper }
