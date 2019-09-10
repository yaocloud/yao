class TestVolumeType < TestYaoResource
  def test_volume
    params = {
        'name' => 'test_volume',
        'description'=> 'this is test volume',
        'is_public' => true
    }

    volume = Yao::VolumeType.new(params)
    assert_equal(volume.name, 'test_volume')
    assert_equal(volume.description, 'this is test volume')
    assert_equal(volume.is_public, true)
  end
end
