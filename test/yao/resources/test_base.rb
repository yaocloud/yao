class TestResourceBase < TestYaoResource
  def setup
    stub(Yao::Resources::Base).get { Yao::Resources::Base.new({"id" => "foor", "name" => "bar"}) }
  end

  def test_friendly_attributes
    base = Yao::Resources::Base.new({"id" => "foor"})
    base.class.friendly_attributes(:name)
    assert_equal("bar", base.name)

    base = Yao::Resources::Base.new({"name" => "bar"})
    base.class.friendly_attributes(:name)
    assert_equal("bar", base.name)
  end

  def test_map_attribute_to_resource
    base = Yao::Resources::Base.new("string" => "hoge")
    base.class.map_attribute_to_resource string: String
    assert_equal("hoge", base.string)

    base = Yao::Resources::Base.new({"empty" => ""})
    base.class.map_attribute_to_resource empty: NilClass
    assert_equal(nil, base.empty)
  end

end
