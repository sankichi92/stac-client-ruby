# frozen_string_literal: true

require_relative 'item_collection'

module STAC
  class Client
    # Represents a deferred query to a \STAC search endpoint as described in the
    # {STAC API - Item Search spec}[https://github.com/radiantearth/stac-api-spec/tree/master/item-search]
    class ItemSearch
      attr_reader :client

      def initialize(client:, url:, method: 'GET', params: {}, headers: {})
        @client = client
        @url = url
        @method = method
        @params = params
        @headers = headers
      end

      # Returns search results as Enumerator::Lazy of Item.
      def items
        pages.lazy.flat_map(&:features)
      end

      # Returns responses as Enumerator of ItemCollection by following next links automatically.
      def pages
        @pages ||= Enumerator.new do |yielder|
          loop do
            response = client.request(@url, method: @method, params: @params, headers: @headers)
            item_collection = API::ItemCollection.from_hash(response)
            yielder << item_collection

            next_link = item_collection.links.find { |link| link.rel == 'next' }
            break unless next_link

            update_attrs!(next_link)
          end
        end
      end

      private

      def update_attrs!(link)
        @url = link.href
        @method = link.extra.fetch('method', 'GET')
        @params = if @method == 'GET'
                    {}
                  elsif link.extra['merge']
                    @params.merge(link.extra.fetch('body', {}))
                  else
                    link.extra.fetch('body', {})
                  end
        @headers = if link.extra['merge']
                     @headers.merge(link.extra.fetch('headers', {}))
                   else
                     link.extra.fetch('headers', {})
                   end
      end
    end
  end
end
