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

  def test_map_attributes_to_time
    base = Yao::Resources::Base.new("updated_at" => "2015-01-01T00:00:00Z")
    base.class.map_attributes_to_time :updated_at
    assert_equal(Time.parse("2015-01-01T00:00:00Z"), base.updated_at)

    base = Yao::Resources::Base.new("updated_at" => nil)
    base.class.map_attributes_to_time :updated_at
    assert(base.updated_at.nil?)
  end

  def test_update
    stub(Yao::Resources::Base).update('foo', {name: 'BAR'}) { Yao::Resources::Base.new('id' => 'foo', 'name' => 'BAR')}
    base = Yao::Resources::Base.new({'id' => 'foo', 'name' => 'bar'})
    got = base.update(name: 'BAR')
    assert_equal(got.name, 'BAR')
  end

  def test_destroy
    stub(Yao::Resources::Base).destroy('foo') { nil }
    base = Yao::Resources::Base.new({'id' => 'foo'})
    got = base.destroy
    assert_equal(got, nil)
  end

  def test_delete
    stub(Yao::Resources::Base).destroy('foo') { nil }
    base = Yao::Resources::Base.new({'id' => 'foo'})
    got = base.delete
    assert_equal(got, nil)
  end

end
