# frozen_string_literal: true

RSpec.describe STAC::Client::ItemSearch do
  subject(:item_search) do
    STAC::Client::ItemSearch.new(client: client, url: url, method: method, params: params)
  end

  let(:client) { instance_double(STAC::Client) }
  let(:url) { '/search' }
  let(:method) { 'GET' }
  let(:params) { {} }

  describe '#items' do
    before do
      allow(client).to receive(:request).and_return(
        {
          'type' => 'FeatureCollection',
          'features' => [
            {
              'stac_version' => '1.0.0',
              'type' => 'Feature',
              'id' => '20201211_223832_CS2',
              'bbox' => [],
              'geometry' => {},
              'properties' => {},
              'collection' => 'simple-collection',
              'links' => [],
              'assets' => {},
            },
          ],
        },
      )
    end

    it 'returns items' do
      items = item_search.items.to_a

      expect(items).to all(be_an_instance_of(STAC::Item))
    end
  end

  describe '#pages' do
    context 'with simple GET based search' do
      let(:url) { '/search?bbox=-110,39.5,-105,40.5' }
      let(:next_url) { 'https://stac-api.example.com/search?page=2' }

      before do
        allow(client).to receive(:request).and_return(
          {
            'type' => 'FeatureCollection',
            'features' => [],
            'links' => [
              {
                'rel' => 'next',
                'href' => next_url,
                'type' => 'application/geo+json',
              },
            ],
          },
          {
            'type' => 'FeatureCollection',
            'features' => [],
          },
        )
      end

      xit 'follows the next link href for the next request' do
        pages = item_search.pages.to_a

        expect(pages).to all(be_an_instance_of(STAC::Client::ItemCollection))
        expect(client).to have_received(:request).with(url, method: 'GET', params: {}, headers: {})
        expect(client).to have_received(:request).with(next_url, method: 'GET', params: {}, headers: {})
      end
    end

    context 'with POST search with body and merge' do
      let(:method) { 'POST' }
      let(:params) do
        { 'bbox' => [-110, 39.5, -105, 40.5] }
      end

      before do
        allow(client).to receive(:request).and_return(
          {
            'type' => 'FeatureCollection',
            'features' => [],
            'links' => [
              {
                'rel' => 'next',
                'href' => 'https://stac-api.example.com/search',
                'type' => 'application/geo+json',
                'method' => 'POST',
                'body' => {
                  'page' => 2,
                  'limit' => 10,
                },
                'merge' => true,
              },
            ],
          },
          {
            'type' => 'FeatureCollection',
            'features' => [],
            'links' => [
              {
                'rel' => 'next',
                'href' => 'https://stac-api.example.com/search',
                'type' => 'application/geo+json',
                'method' => 'POST',
                'body' => {
                  'next' => 'a9f3kfbc98e29a0da23',
                },
              },
            ],
          },
          {
            'type' => 'FeatureCollection',
            'features' => [],
          },
        )
      end

      it 'merges params for the next request' do
        item_search.pages.to_a

        expect(client).to have_received(:request).with(
          'https://stac-api.example.com/search',
          method: 'POST',
          params: {
            'bbox' => [-110, 39.5, -105, 40.5],
            'page' => 2,
            'limit' => 10,
          },
          headers: {},
        ).at_least(:once)
      end
    end

    context 'with POST search with body, without merge' do
      let(:method) { 'POST' }
      let(:params) do
        { 'bbox' => [-110, 39.5, -105, 40.5] }
      end

      before do
        allow(client).to receive(:request).and_return(
          {
            'type' => 'FeatureCollection',
            'features' => [],
            'links' => [
              {
                'rel' => 'next',
                'href' => 'https://stac-api.example.com/search',
                'type' => 'application/geo+json',
                'method' => 'POST',
                'body' => {
                  'next' => 'a9f3kfbc98e29a0da23',
                },
              },
            ],
          },
          {
            'type' => 'FeatureCollection',
            'features' => [],
          },
        )
      end

      it 'replaces params for the next request' do
        item_search.pages.to_a

        expect(client).to have_received(:request).with(
          'https://stac-api.example.com/search',
          method: 'POST',
          params: {
            'next' => 'a9f3kfbc98e29a0da23',
          },
          headers: {},
        ).at_least(:once)
      end
    end

    context 'with POST search using headers' do
      let(:method) { 'POST' }
      let(:params) do
        {
          'bbox' => [-110, 39.5, -105, 40.5],
          'page' => 2,
          'limit' => 10,
        }
      end

      before do
        allow(client).to receive(:request).and_return(
          {
            'type' => 'FeatureCollection',
            'features' => [],
            'links' => [
              {
                'rel' => 'next',
                'href' => 'https://stac-api.example.com/search',
                'type' => 'application/geo+json',
                'method' => 'POST',
                'headers' => {
                  'Search-After' => 'LC81530752019135LGN00',
                },
              },
            ],
          },
          {
            'type' => 'FeatureCollection',
            'features' => [],
          },
        )
      end

      it 'sets headers for the next request' do
        item_search.pages.to_a

        expect(client).to have_received(:request).with(
          'https://stac-api.example.com/search',
          method: 'POST',
          params: {},
          headers: { 'Search-After' => 'LC81530752019135LGN00' },
        ).at_least(:once)
      end
    end
  end
end
