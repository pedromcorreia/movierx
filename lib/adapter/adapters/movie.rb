# frozen_string_literal: true

# Adapter resposible to the module for find and create the response for the
# request
module Adapter
  module Adapters
    # Movie is responsible find the current movie_id
    class Movie
      attr_accessor :query

      def initialize(options = {})
        @query = options[:query]
      end

      def call
        request
      end

      private

      def request
        Faraday.get("http://localhost:3030/movies?ids=#{query}")
      end
    end
  end
end
