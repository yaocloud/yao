class TestResourceBase < TestYaoResouce
  def setup
    stub(Yao::Resources::Base).get { Yao::Resources::Base.new({"id" => "foor", "name" => "bar"}) }
  end

  def test_friendly_attributes
    base = Yao::Resources::Base.new({"id" => "foor"})
    base.class.friendly_attributes(:name)
    assert_equal(base.name, "bar")

    base = Yao::Resources::Base.new({"name" => "bar"})
    base.class.friendly_attributes(:name)
    assert_equal(base.name, "bar")
  end
end
