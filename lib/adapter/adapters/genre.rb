# frozen_string_literal: true

# Adapter resposible to the module for find and create the response for the
# request
module Adapter
  module Adapters
    # Genre is responsible find the current genre_id
    class Genre
      attr_accessor :query, :limit, :offset

      def initialize(options = {})
        @query = options[:query]
        @offset = options[:offset]
        @limit = options[:limit]
      end

      def call
        request
      end

      private

      def request
        Faraday.get("http://localhost:3040/movies?genre=#{@query}&offset=#{@offset}&limit=#{@limit}")
      end
    end
  end
end
