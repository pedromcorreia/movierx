# frozen_string_literal: true

module Adapter
  module Adapters
    # TODO: add here a good description
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
