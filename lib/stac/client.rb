# frozen_string_literal: true

require 'stac'
require_relative 'client/version'

module STAC
  # Client for interacting with the root of a STAC API.
  class Client
    class << self
      # Returns a Client instance from STAC API landing page URL.
      #
      # Raises STAC::TypeError when the fetched JSON from the given URL is not STAC Catalog.
      def from_url(url)
        obj = STAC.from_url(url)
        unless obj.instance_of?(Catalog)
          raise TypeError, %(could not resolve fetched JSON into STAC::Catalog: #{obj.class})
        end

        new(obj)
      end
    end

    attr_reader :catalog

    def initialize(catalog)
      @catalog = catalog
    end
  end
end
