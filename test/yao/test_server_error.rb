class TestServerError < Test::Unit::TestCase
  def test_detects_error_with_env
    env = Faraday::Env.new
    env.body = {"itemNotFound"=>{"message"=>"Image not found.", "code"=>404}}
    env.status = 404

    error = Yao::ServerError.detect(env)
    assert { error.is_a? Yao::ItemNotFound }
    assert { error.env.is_a? Faraday::Env }
    assert { error.status == 404 }
    assert { error.env.body["itemNotFound"]["message"] == "Image not found." }
  end
end
