class TestKeypair < Test::Unit::TestCase

  def setup
    Yao.default_client.pool["compute"] = Yao::Client.gen_client("https://example.com:12345")
  end

  def test_keypair
    # https://docs.openstack.org/api-ref/compute/?expanded=list-keypairs-detail#list-keypairs
    params = {
      "fingerprint" => "7e:eb:ab:24:ba:d1:e1:88:ae:9a:fb:66:53:df:d3:bd",
      "name" => "keypair-5d935425-31d5-48a7-a0f1-e76e9813f2c3",
      "type" => "ssh",
      "public_key" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkF3MX59OrlBs3dH5CU7lNmvpbrgZxSpyGjlnE8Flkirnc/Up22lpjznoxqeoTAwTW034k7Dz6aYIrZGmQwe2TkE084yqvlj45Dkyoj95fW/sZacm0cZNuL69EObEGHdprfGJQajrpz22NQoCD8TFB8Wv+8om9NH9Le6s+WPe98WC77KLw8qgfQsbIey+JawPWl4O67ZdL5xrypuRjfIPWjgy/VH85IXg/Z/GONZ2nxHgSShMkwqSFECAC5L3PHB+0+/12M/iikdatFSVGjpuHvkLOs3oe7m6HlOfluSJ85BzLWBbvva93qkGmLg4ZAc8rPh2O+YIsBUHNLLMM/oQp Generated-by-Nova\n"
    }

    keypair = Yao::Keypair.new(params)

    # friendly_attributes
    assert_equal(keypair.name, "keypair-5d935425-31d5-48a7-a0f1-e76e9813f2c3")
    assert_equal(keypair.fingerprint, "7e:eb:ab:24:ba:d1:e1:88:ae:9a:fb:66:53:df:d3:bd")
    assert_equal(keypair.public_key, <<EOS)
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkF3MX59OrlBs3dH5CU7lNmvpbrgZxSpyGjlnE8Flkirnc/Up22lpjznoxqeoTAwTW034k7Dz6aYIrZGmQwe2TkE084yqvlj45Dkyoj95fW/sZacm0cZNuL69EObEGHdprfGJQajrpz22NQoCD8TFB8Wv+8om9NH9Le6s+WPe98WC77KLw8qgfQsbIey+JawPWl4O67ZdL5xrypuRjfIPWjgy/VH85IXg/Z/GONZ2nxHgSShMkwqSFECAC5L3PHB+0+/12M/iikdatFSVGjpuHvkLOs3oe7m6HlOfluSJ85BzLWBbvva93qkGmLg4ZAc8rPh2O+YIsBUHNLLMM/oQp Generated-by-Nova
EOS
  end
end
