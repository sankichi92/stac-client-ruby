# frozen_string_literal: true

require 'stac'
require_relative 'client/conformance'
require_relative 'client/http_client'
require_relative 'client/item_collection'
require_relative 'client/item_search'
require_relative 'client/version'

STAC.default_http_client = STAC::Client::HTTPClient.new
STAC::ObjectResolver.resolvables << STAC::Client::ItemCollection

module STAC
  # Client for interacting with the root of a \STAC API.
  class Client
    class << self
      # Returns a Client instance from \STAC API landing page URL.
      #
      # Raises STAC::TypeError when the fetched JSON from the given URL is not \STAC Catalog.
      def from_url(url, params: {}, headers: {}, **http_options)
        http_client = HTTPClient.new(params: params, headers: headers, **http_options.merge(url: url))
        obj = STAC.from_url(url, http_client: http_client)
        unless obj.instance_of?(Catalog)
          raise TypeError, "could not resolve fetched JSON into STAC::Catalog: #{obj.class}"
        end

        new(obj, http_client: http_client)
      end
    end

    # STAC::Catalog instance of a \STAC API landing page.
    attr_reader :catalog, :http_client

    def initialize(catalog, http_client: HTTPClient.new)
      @catalog = catalog
      @http_client = http_client
    end

    def request(url, method: 'GET', params: {}, headers: {})
      if method.to_s.upcase == 'POST'
        http_client.post(url, params: params, headers: headers)
      else
        http_client.get(url, params: params, headers: headers)
      end
    end

    # Returns the value of "conformsTo" field.
    def conformances
      catalog.extra.fetch('conformsTo', [])
    end

    # Returns wether the API conforms to the given standard.
    #
    # The argument should be a constant of Conformance.
    def conforms_to?(conformance)
      conformances.any? { |c| conformance.match?(c) }
    end

    # Queries the /search endpoint using the given parameters and returns ItemSearch.
    #
    # Raises NotImplementedError when the Catalog have no rel="search" links.
    def search(**params)
      search_links = catalog.links.select do |link|
        link.rel == 'search' && link.type == 'application/geo+json'
      end
      raise NotImplementedError, 'catalog does not have rel="search" links' if search_links.empty?

      support_post = search_links.any? { |link| link.extra['method'] == 'POST' }

      ItemSearch.new(
        client: self,
        url: search_links.first.href,
        method: support_post ? 'POST' : 'GET',
        params: params.transform_keys(&:to_s),
      ).tap { |item_search| item_search.pages.first }
    end
  end
end
