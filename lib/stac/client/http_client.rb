# frozen_string_literal: true

require 'faraday'
require_relative 'version'

module STAC
  class Client
    # A HTTP Client, wrapper of Faraday[https://github.com/lostisland/faraday].
    class HTTPClient
      DEFAULT_HEADERS = { 'User-Agent' => "stac-client-ruby v#{VERSION}" }.freeze # :nodoc:

      attr_reader :connection

      def initialize(**options)
        options = options.dup
        options[:headers] = DEFAULT_HEADERS.merge(options[:headers].to_h)
        @connection = Faraday.new(options) do |conn|
          conn.request :json
          conn.response :json
          conn.response :raise_error # TODO: Raise gem specific errors instead of Faraday errors
        end
      end

      # Makes a HTTP GET request and returns the response body.
      def get(url, params: {}, headers: {})
        response = @connection.get(url, params, headers)
        response.body
      end

      # Makes a HTTP POST request and returns the response body.
      def post(url, params: {}, headers: {})
        response = @connection.post(url, params, headers)
        response.body
      end
    end
  end
end
