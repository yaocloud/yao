class TestAuth < Test::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_works
    assert { Yao::Auth.respond_to?(:new) }
  end
end
