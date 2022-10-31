# frozen_string_literal: true

module STAC
  class Client
    SPEC_VERSION = '1.0'

    module Conformance
      BASE_URL = %r{https://api\.stacspec\.org/v#{SPEC_VERSION}\.[\w.-]+/} # :no_doc:

      CORE = /#{BASE_URL}core/
      COLLECTIONS = /#{BASE_URL}collections/
      FEATURES = /#{BASE_URL}ogcapi-features/
      ITEM_SEARCH = /#{BASE_URL}item-search/
      BROWSABLE = /#{BASE_URL}browsable/
    end
  end
end
