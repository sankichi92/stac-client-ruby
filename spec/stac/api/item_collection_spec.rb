# frozen_string_literal: true

RSpec.describe STAC::API::ItemCollection do
  subject(:item_collection) { STAC::API::ItemCollection.from_hash(read_fixture_as_hash('item_collection.json')) }

  describe '.from_hash' do
    let(:hash) do
      {
        'type' => 'FeatureCollection',
        'features' => [],
      }
    end

    it 'deserializes an ItemCollection from a Hash' do
      item_collection = STAC::API::ItemCollection.from_hash(hash)

      expect(item_collection).to be_an_instance_of STAC::API::ItemCollection
      expect(item_collection.features).to eq []
    end

    context 'when a required field is missing' do
      it 'raises ArgumentError' do
        expect { STAC::API::ItemCollection.from_hash(hash.except('features')) }.to raise_error ArgumentError
      end
    end
  end
end
