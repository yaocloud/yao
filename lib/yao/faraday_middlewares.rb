require 'faraday'
require 'yao/error'

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
      @token.refresh(Yao.default_client.default)
    end

    env[:request_headers]['X-Auth-Token'] = @token.to_s
    @app.call(env)
  end
end
Faraday::Request.register_middleware os_token: -> { Faraday::Request::OSToken }

class Faraday::Request::ReadOnly
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) if allowed_request?(env)

    if Yao.config.raise_on_write
      raise Yao::ReadOnlyViolationError
    elsif Yao.config.noop_on_write
      env
    else
      @app.call(env)
    end
  end

  private

  ALLOWED_REQUESTS = [
    {method: :post, path: "/tokens"}
  ]

  def allowed_request?(env)
    return true if env[:method] == :get

    ALLOWED_REQUESTS.any? do |allowed|
      env[:method] == allowed[:method] && env[:url].path == allowed[:path]
    end
  end
end
Faraday::Request.register_middleware read_only: -> { Faraday::Request::ReadOnly }

class Faraday::Response::OSDumper < Faraday::Response::Middleware
  def on_complete(env)
    require 'pp'

    body = if env.response_headers["content-type"] == "application/json"
             JSON.parse(env.body)
           else
             env.body
           end
    body = conseal_token_in_body(body)

    request_headers = conseal_token_in_request_headers(env.request_headers.dup)
    response_headers= conseal_token_in_response_headers(env.response_headers.dup)

    params = [
      env.url.to_s,
      body,
      request_headers,
      response_headers,
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

  private
  def conseal_token_in_body(body)
    # for keystone v2.0
    if body.is_a?(Hash) && token = body.dig("access", "token", "id")
      body["access"]["token"]["id"] = hashed_token(token)
    end
    body
  end

  def conseal_token_in_request_headers(headers)
    if token = headers["X-Auth-Token"]
      headers["X-Auth-Token"] = hashed_token(token)
    end
    headers
  end

  def conseal_token_in_response_headers(headers)
    if token = headers["x-subject-token"]
      headers["x-subject-token"] = hashed_token(token)
    end
    headers
  end

  def hashed_token(token)
    require 'openssl'

    # This format was based on openstack client.
    "{SHA256}" + OpenSSL::Digest::SHA256.hexdigest(token)
  end
end
Faraday::Response.register_middleware os_dumper: -> { Faraday::Response::OSDumper }

class Faraday::Response::OSResponseRecorder < Faraday::Response::Middleware
  def on_complete(env)
    require 'tmpdir'

    @@tmpdir ||= Dir.mktmpdir('yao-')
    root = Pathname.new(@@tmpdir)

    path = [env.method.to_s.upcase, env.url.path.gsub('/', '-')].join("-") + ".json"

    puts root.join(path)
    File.open(root.join(path), 'w') do |f|
      f.write env.body
    end
  end
end
Faraday::Response.register_middleware os_response_recorder: -> { Faraday::Response::OSResponseRecorder }

class Faraday::Response::OSErrorDetector < Faraday::Response::Middleware
  # TODO: Better handling, respecting official doc
  def on_complete(env)
    return if env.success?

    raise Yao::ServerError.detect(env)
  end
end
Faraday::Response.register_middleware os_error_detector: -> { Faraday::Response::OSErrorDetector }
