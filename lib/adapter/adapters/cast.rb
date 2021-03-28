# frozen_string_literal: true

# Adapter resposible to the module for find and create the response for the
# request
module Adapter
  module Adapters
    # Cast is responsible find the current artist_id
    class Cast
      HOST = ENV['CAST']
      attr_accessor :query

      def initialize(options = {})
        @query = options[:query]
      end

      def call
        request
      end

      private

      def request
        Faraday.get("#{HOST}artists?ids=#{@query}")
      end
    end
  end
end
