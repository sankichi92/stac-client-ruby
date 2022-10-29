# frozen_string_literal: true

RSpec.describe STAC::Client::HTTPClient do
  subject(:client) { STAC::Client::HTTPClient.new }

  describe '#get' do
    let(:url) { 'https://example.com/' }

    before do
      stub_request(:get, url).to_return(body: 'body')
    end

    it 'makes a HTTP GET request and returns the response body' do
      response = client.get(URI(url))

      expect(WebMock).to have_requested(:get, url).with(headers: { 'User-Agent' => /\Astac-client-ruby/ })
      expect(response).to eq 'body'
    end
  end
end
