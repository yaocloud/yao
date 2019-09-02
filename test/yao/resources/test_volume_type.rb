class TestVolumeType < TestYaoResouce
  def test_volume
    params = {
        'name' => 'test_volume',
        'description'=> 'this is test volume',
        'is_public' => true
    }

    volume = Yao::VolumeType.new(params)
    assert_equal('test_volume', volume.name)
    assert_equal('this is test volume', volume.description)
    assert_equal(true, volume.is_public)
  end
end
