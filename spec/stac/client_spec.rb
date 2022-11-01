# frozen_string_literal: true

RSpec.describe STAC::Client do
  subject(:client) { STAC::Client.new(read_fixture_as_object('landing_page.json')) }

  describe '.from_url' do
    let(:url) { 'https://stac-api.example.com/' }

    before do
      stub_request(:get, url).to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: read_fixture('landing_page.json'),
      )
    end

    it 'returns STAC::Client' do
      client = STAC::Client.from_url(url)

      expect(client).to be_an_instance_of STAC::Client
    end

    context 'when responded JSON is not Catalog type' do
      before do
        stub_request(:get, url).to_return(
          headers: { 'Content-Type' => 'application/json' },
          body: {
            'stac_version' => '1.0.0',
            'type' => 'Feature',
            'id' => '20201211_223832_CS2',
            'bbox' => [],
            'geometry' => {},
            'properties' => {},
            'collection' => 'simple-collection',
            'links' => [],
            'assets' => {},
          }.to_json,
        )
      end

      it 'raises STAC::TypeError' do
        expect { STAC::Client.from_url(url) }.to raise_error STAC::TypeError
      end
    end
  end

  describe '#conforms_to?' do
    context 'when API conforms the given conformance' do
      it 'returns true' do
        result = client.conforms_to?(STAC::Client::Conformance::ITEM_SEARCH)

        expect(result).to be true
      end
    end

    context 'when API does not conform the given conformance' do
      before do
        client.catalog.extra['conformsTo'] = []
      end

      it 'returns false' do
        result = client.conforms_to?(STAC::Client::Conformance::ITEM_SEARCH)

        expect(result).to be false
      end
    end
  end

  describe '#search' do
    before do
      stub_request(:get, 'https://stac-api.example.com/search').with(query: hash_including(:bbox)).to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: {
          'type' => 'FeatureCollection',
          'features' => [],
        }.to_json,
      )
    end

    it 'makes a request and returns ItemSearch' do
      item_search = client.search(bbox: [-110, 39.5, -105, 40.5])

      expect(WebMock).to have_requested(:get, 'https://stac-api.example.com/search?bbox=-110,39.5,-105,40.5&limit=100')
        .at_least_once # For RBS test
      expect(item_search).to be_an_instance_of STAC::Client::ItemSearch
    end

    context 'when catalog does not have rel="search" link' do
      before do
        client.catalog.links.reject! { |link| link.rel == 'search' }
      end

      it 'raises NotImplementedError' do
        expect { client.search }.to raise_error NotImplementedError
      end
    end
  end
end
