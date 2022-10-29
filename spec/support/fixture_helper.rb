# frozen_string_literal: true

module FixtureHelper
  def landing_page_json
    File.read(File.expand_path('../fixtures/landing_page.json', __dir__))
  end

  def landing_page_catalog
    STAC.from_file(File.expand_path('../fixtures/landing_page.json', __dir__))
  end
end
