# frozen_string_literal: true

RSpec.describe STAC::Client do
  describe '.from_url' do
    let(:url) { 'https://stac-api.example.com/' }

    before do
      stub_request(:get, url).to_return(body: landing_page_json)
    end

    it 'returns STAC::Client' do
      client = STAC::Client.from_url(url)

      expect(client).to be_an_instance_of STAC::Client
    end

    context 'when responded JSON is not Catalog type' do
      before do
        stub_request(:get, url).to_return(body: {
          'stac_version' => '1.0.0',
          'type' => 'Feature',
          'id' => '20201211_223832_CS2',
          'bbox' => [],
          'geometry' => {},
          'properties' => {},
          'collection' => 'simple-collection',
          'links' => [],
          'assets' => {},
        }.to_json)
      end

      it 'raises STAC::TypeError' do
        expect { STAC::Client.from_url(url) }.to raise_error STAC::TypeError
      end
    end
  end
end
