# frozen_string_literal: true

require 'faraday'
require_relative 'version'

module STAC
  class Client
    # A HTTP Client, wrapper of Faraday[https://github.com/lostisland/faraday].
    class HTTPClient
      DEFAULT_HEADERS = { 'User-Agent' => "stac-client-ruby v#{VERSION}" }.freeze # :no_doc:

      attr_reader :connection

      def initialize(**options)
        options = options.dup
        options[:headers] = DEFAULT_HEADERS.merge(options[:headers].to_h)
        @connection = Faraday.new(options) do |conn|
          conn.response :raise_error # TODO: Raise gem specific errors instead of Faraday errors
        end
      end

      # Makes a HTTP request and returns the response body as String.
      def get(uri)
        response = @connection.get(uri)
        response.body
      end
    end
  end
end
