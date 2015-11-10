require 'faraday'

class Faraday::Request::Accept
  def initialize(app, accept=nil)
    @app = app
    @accept = accept || 'application/json'
  end

  def call(env)
    env[:request_headers]['Accept'] = @accept
    @app.call(env)
  end
end
Faraday::Request.register_middleware accept: -> { Faraday::Request::Accept }

class Faraday::Request::OSToken
  def initialize(app, token)
    @app = app
    @token = token
  end

  def call(env)
    if @token.expired?
      @token.reflesh(Yao.default_client.default)
    end

    env[:request_headers]['X-Auth-Token'] = @token.to_s
    @app.call(env)
  end
end
Faraday::Request.register_middleware os_token: -> { Faraday::Request::OSToken }

class Faraday::Response::OSDumper < Faraday::Response::Middleware
  def on_complete(env)
    require 'pp'

    body = if env.response_headers["content-type"] == "application/json"
             JSON.parse(env.body)
           else
             env.body
           end

    params = [
      env.url.to_s,
      body,
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
Faraday::Response.register_middleware os_dumper: -> { Faraday::Response::OSDumper }

class Faraday::Response::OSResponseRecorder < Faraday::Response::Middleware
  def on_complete(env)
    require 'pathname'
    root = Pathname.new(File.expand_path('../../../tmp', __FILE__))
    path = [env.method.to_s.upcase, env.url.path.gsub('/', '-')].join("-") + ".json"

    puts root.join(path)
    File.open(root.join(path), 'w') do |f|
      f.write env.body
    end
  end
end
Faraday::Response.register_middleware os_response_recorder: -> { Faraday::Response::OSResponseRecorder }

require 'yao/server_error'
class Faraday::Response::OSErrorDetector < Faraday::Response::Middleware
  # TODO: Better handling, respecting official doc
  def on_complete(env)
    return if env.success?

    raise Yao::ServerError.detect(env)
  end
end
Faraday::Response.register_middleware os_error_detector: -> { Faraday::Response::OSErrorDetector }
