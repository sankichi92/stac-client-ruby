# frozen_string_literal: true

require 'json'
require_relative 'item_collection'

module STAC
  class Client
    # Represents a deferred query to a \STAC search endpoint as described in the
    # {STAC API - Item Search spec}[https://github.com/radiantearth/stac-api-spec/tree/master/item-search]
    class ItemSearch
      DEFAULT_PARAMS = { 'limit' => 100 }.freeze # :nodoc:

      attr_reader :client

      def initialize(client:, url:, method: 'GET', params: {}, headers: {})
        @client = client
        @url = url
        @method = method
        @params = DEFAULT_PARAMS.merge(params.transform_keys(&:to_s))
        @headers = headers
      end

      # Returns search results as Enumerator::Lazy of Item with automatic pagination.
      def items
        pages.lazy.flat_map(&:features)
      end

      # Returns responses as Enumerator of ItemCollection by following next links automatically.
      def pages
        @pages ||= Enumerator.new do |yielder|
          loop do
            response = request!
            item_collection = ItemCollection.from_hash(response)
            yielder << item_collection

            next_link = item_collection.find_link(rel: 'next')
            break unless next_link

            update_attrs!(next_link)
          end
        end
      end

      private

      def request!
        if @method == 'GET'
          client.get(@url, params: params_for_get, headers: @headers)
        else
          client.post(@url, params: @params, headers: @headers)
        end
      end

      def params_for_get
        params = @params.dup
        params['bbox'] = params['bbox']&.join(',')
        params['ids'] = params['ids']&.join(',')
        params['intersects'] = params['intersects']&.to_json
        params['collections'] = params['collections']&.join(',')
        params.compact
      end

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
