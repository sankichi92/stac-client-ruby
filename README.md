# stac-client-ruby

A Ruby client for working with [STAC API](https://github.com/radiantearth/stac-api-spec).

This gem is built on [satc-ruby](https://github.com/sankichi92/stac-ruby), and this gem's implementation refers to [PySTAC Client](https://github.com/stac-utils/pystac-client).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add stac-client

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install stac-client

## Getting Started

```ruby
require 'stac-client'

# Create a client instance from a STAC API root URL.
client = STAC::Client.from_url('https://planetarycomputer.microsoft.com/api/stac/v1')

# Search items.
res = client.search(
  collections: ['landsat-8-c2-l2'],
  bbox: [140, 36, 140.5, 36.5],
  datetime: '2022-01-01T00:00:00Z/2022-02-01T00:00:00Z',
)
puts "#{res.matched} items matched."

# `#items` returns the all resulting items with automatic pagination.
res.items.each do |item|
  puts item.id
end
```

## Documentation

https://sankichi92.github.io/stac-client-ruby/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sankichi92/stac-client-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sankichi92/stac-client-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the stac-client-ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sankichi92/stac-client-ruby/blob/main/CODE_OF_CONDUCT.md).
