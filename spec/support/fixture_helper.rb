# frozen_string_literal: true

module FixtureHelper
  def read_fixture(file_name)
    File.read(File.expand_path("../fixtures/#{file_name}", __dir__))
  end

  def read_fixture_as_object(file_name)
    STAC.from_file(File.expand_path("../fixtures/#{file_name}", __dir__))
  end
end
