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
Oslo.configure do
  auth_url "http://keystone.example.local:8080/v2.0/tokens"
  tenant   "fooproject"
  user     "udzura"
  password "tonk0tsu-r@men"
end

Oslo::Nova.create_instance( ... )
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/oslo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
