# frozen_string_literal: true

module STAC
  class Client
    SPEC_VERSION = '1.0' # :nodoc:

    # Namespace for Conformance URI constants.
    module Conformance
      BASE_URL = %r{https://api\.stacspec\.org/v#{SPEC_VERSION}\.[\w.-]+/} # :nodoc:

      # {STAC API - Core}[https://github.com/radiantearth/stac-api-spec/tree/main/core] conformance URI regexp.
      CORE = /#{BASE_URL}core/

      # {STAC API - Collections}[https://github.com/radiantearth/stac-api-spec/tree/main/ogcapi-features] conformance
      # URI regexp.
      COLLECTIONS = /#{BASE_URL}collections/

      # {STAC API - Features}[https://github.com/radiantearth/stac-api-spec/tree/main/ogcapi-features] conformance URI
      # regexp.
      FEATURES = /#{BASE_URL}ogcapi-features/

      # {STAC API - Item Search}[https://github.com/radiantearth/stac-api-spec/tree/main/item-search] conformance URI
      # regex.
      ITEM_SEARCH = /#{BASE_URL}item-search/

      # {STAC API - Browseable}[https://github.com/radiantearth/stac-api-spec/tree/main/core] conformance URI regexp.
      BROWSABLE = /#{BASE_URL}browsable/
    end
  end
end
