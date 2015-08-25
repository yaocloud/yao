# Oslo

OpenStack API Wrapper that rocks!!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oslo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oslo

## Usage

```ruby
require 'oslo'

Oslo.configure do
  auth_url    "http://keystone.example.local:8080/v2.0/tokens"
  tenant_name "fooproject"
  username    "udzura"
  password    "tonk0tsu-r@men"
end

Oslo::Network.list # list up networks...
Oslo::Server.list_detail # list up instances...
```

## Pro tips

You can use a prittier namespace:

```ruby
# Instead of require-ing 'oslo'
require 'oslo/is_openstack_client'

OpenStack.configure do
  auth_url    "http://keystone.example.local:8080/v2.0/tokens"
  tenant_name "fooproject"
  username    "udzura"
  password    "tonk0tsu-r@men"
end

OpenStack::Server.list_detail # And let's go on
```

## Contributing

1. Fork it ( https://github.com/udzura/oslo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
