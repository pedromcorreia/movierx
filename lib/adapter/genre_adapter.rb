# frozen_string_literal: true

# TODO: add here a good description
module Adapter
  class GenreAdapter

    require 'dalli'

    def initialize(genre:, offset:, limit:)
      @genre = genre
      @offset = offset
      @limit = limit
    end

    def call
      dc = Dalli::Client.new('localhost:11211')
      value = dc.get({id: @genre, type: "genre"})

      return value if value

      result = request(@genre, @offset, @limit)
      return unless result

      result_parsed = JSON.parse(result.body)["data"]
      dc.set({id: @genre, type: "genre"}, result_parsed)
      result_parsed
    end

    private

    # :reek:InstanceVariableAssumption
    def request(genre, offset, limit)
      result =
        Faraday.get("http://localhost:3040/movies?genre=#{genre}&offset=#{offset}&limit=#{limit}")
      if result.status == 500
        nil
      else
        result
      end
    end
  end
end
