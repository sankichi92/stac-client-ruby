# frozen_string_literal: true

RSpec.describe STAC::Client::HTTPClient do
  subject(:client) { STAC::Client::HTTPClient.new }

  describe '#get' do
    let(:url) { 'https://example.com/' }

    before do
      stub_request(:get, url).to_return(headers: { 'Content-Type': 'application/json' }, body: { foo: 'bar' }.to_json)
    end

    it 'makes a HTTP GET request and returns the response body' do
      response = client.get(URI(url))

      expect(WebMock).to have_requested(:get, url).with(headers: { 'User-Agent' => /\Astac-client-ruby/ })
      expect(response).to eq({ 'foo' => 'bar' })
    end
  end

  describe '#post' do
    let(:url) { 'https://example.com/' }
    let(:params) { { 'hoge' => 'fuga' } }

    before do
      stub_request(:post, url).to_return(headers: { 'Content-Type': 'application/json' }, body: { foo: 'bar' }.to_json)
    end

    it 'makes a HTTP POST request and returns the response body' do
      response = client.post(url, params: params)

      expect(WebMock).to have_requested(:post, url).with(
        body: params.to_json,
        headers: {
          'User-Agent' => /\Astac-client-ruby/,
          'Content-Type' => 'application/json',
        },
      )
      expect(response).to eq({ 'foo' => 'bar' })
    end
  end
end
