module Yao
  class ServerError < ::StandardError
    def initialize(message, requested_env)
      @status = requested_env.status
      @env = requested_env
      super(message)
    end
    attr_reader :status, :env

    def self.detect(env)
      case env.status
      when 400
        if env.body && env.body["computeFault"]
          ComputeFault.new(extract_message(env.body), env)
        elsif env.body && env.body.to_a.join.include?('NetworkNotFound')
          NetworkNotFound.new(extract_message(env.body), env)
        else
          BadRequest.new(extract_message(env.body), env)
        end
      when 401
        Unauthorized.new(extract_message(env.body), env)
      when 404
        if env.body && env.body["itemNotFound"]
          ItemNotFound.new(extract_message(env.body), env)
        else
          NotFound.new("The resource could not be found.", env)
        end
      when 405
        BadMethod.new(extract_message(env.body), env)
      when 409
        if env.body && env.body["buildInProgress"]
          BuildInProgress.new(extract_message(env.body), env)
        else
          Conflict.new(extract_message(env.body), env)
        end
      when 413
        OverLimit.new(extract_message(env.body), env)
      when 415
        BadMediaType.new(extract_message(env.body), env)
      when 422
        UnprocessableEntity.new(extract_message(env.body), env)
      when 500
        ComputeFault.new(extract_message(env.body), env)
      when 503
        if env.body && env.body[" serverCapacityUnavailable"]
          ServerCapacityUnavailable.new(extract_message(env.body), env)
        else
          ServiceUnavailable.new(extract_message(env.body), env)
        end
      else
        new(extract_message(body), env)
      end
    rescue => e
      new("Detection failed - %s" % e.message, env)
    end

    def self.extract_message(body)
      body.values.first["message"] or raise
    rescue
      "Something is wrong. - %s" % body.inspect
    end
  end

  # Errors as OpenStack error type
  class ComputeFault              < ServerError; end
  class UnprocessableEntity       < ServerError; end
  class ItemNotFound              < ServerError; end
  class ServiceUnavailable        < ServerError; end
  class NotFound                  < ServerError; end
  class BadRequest                < ServerError; end
  class Unauthorized              < ServerError; end
  class Forbidden                 < ServerError; end
  class BadMethod                 < ServerError; end
  class OverLimit                 < ServerError; end
  class BadMediaType              < ServerError; end
  class NetworkNotFound           < ServerError; end
  class BuildInProgress           < ServerError; end
  class Conflict                  < ServerError; end
  class ServerCapacityUnavailable < ServerError; end

end
