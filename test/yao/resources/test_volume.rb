class TestVolume < Test::Unit::TestCase
  def test_volume
    params = {
        'name' => 'cinder',
        'size' => 10
    }

    volume = Yao::Volume.new(params)
    assert_equal('cinder', volume.name)
    assert_equal(10, volume.size)
  end
end
