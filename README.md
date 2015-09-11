# Yao

YAO is a Yet Another OpenStack API Wrapper that rocks!! [![Build Status](https://travis-ci.org/yaocloud/yao.svg)](https://travis-ci.org/yaocloud/yao)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yao'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yao

## Usage

```ruby
require 'yao'

Yao.configure do
  auth_url    "http://keystone.example.local:8080/v2.0/tokens"
  tenant_name "fooproject"
  username    "udzura"
  password    "tonk0tsu-r@men"
end

Yao::Network.list # list up networks...
Yao::Server.list_detail # list up instances...
```

## Pro tips

You can use a prittier namespace:

```ruby
# Instead of require-ing 'yao'
require 'yao/is_openstack_client'

OpenStack.configure do
  auth_url    "http://keystone.example.local:8080/v2.0/tokens"
  tenant_name "fooproject"
  username    "udzura"
  password    "tonk0tsu-r@men"
end

OpenStack::Server.list_detail # And let's go on
```

## Contributing

1. Fork it ( https://github.com/yaocloud/yao/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
