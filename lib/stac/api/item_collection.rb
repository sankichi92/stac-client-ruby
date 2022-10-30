# frozen_string_literal: true

module STAC
  module API
    # Represents {STAC API - ItemCollection Fragment}[https://github.com/radiantearth/stac-api-spec/tree/main/fragments/itemcollection].
    class ItemCollection < STACObject
      self.type = 'FeatureCollection'

      class << self
        def from_hash(hash)
          h = hash.dup
          h['features'] = h.fetch('features').map { |feature| Item.from_hash(feature) }
          h['links'] ||= []
          h['number_matched'] = h.delete('numberMatched')
          h['number_returned'] = h.delete('numberReturned')
          super(h)
        rescue KeyError => e
          raise ArgumentError, "required field not found: #{e.key}"
        end
      end

      attr_accessor :features, :number_matched, :number_returned

      def initialize(features:, links: [], number_matched: nil, number_returned: nil, stac_extensions: nil, **extra)
        super(links: links, stac_extensions: stac_extensions, **extra)
        @features = features
        @number_matched = number_matched
        @number_returned = number_returned
      end

      def to_h
        super.except('stac_version').merge(
          {
            'numberMatched' => number_matched,
            'numberReturned' => number_returned,
            'features' => features.map(&:to_h),
          }.compact,
        )
      end
    end
  end
end
