# frozen_string_literal: true

module Adapter
  module Adapters
    # TODO: add here a good description
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
