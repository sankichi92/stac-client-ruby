# frozen_string_literal: true

RSpec.describe STAC::Client do
  it 'has a version number' do
    expect(STAC::Client::VERSION).not_to be_nil
  end
end
