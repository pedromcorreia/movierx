# frozen_string_literal: true

# Adapter resposible to the module for find and create the response for the
# request
module Adapter
  module Adapters
    # Movie is responsible find the current movie_id
    class Movie
      HOST = ENV['MOVIE']
      attr_accessor :query

      def initialize(options = {})
        @query = options[:query]
      end

      def call
        request
      end

      private

      def request
        Faraday.get("#{HOST}movies?ids=#{query}")
      end
    end
  end
end
