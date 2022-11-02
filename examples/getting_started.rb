# frozen_string_literal: true

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

# `#items` returns the resulting items with automatic pagination.
res.items.each do |item|
  puts item.id
end
