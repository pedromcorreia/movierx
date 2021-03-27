# frozen_string_literal: true

module Adapter
  # TODO: add here a good description
  class MovieAdapter
    require 'dalli'

    def initialize(ids:)
      @ids = ids
    end

    def call
      dc = Dalli::Client.new('localhost:11211')
      value = dc.get({id: @ids, type: "movie"})

      return value if value

      result = request(@ids)
      return unless result

      result_parsed = JSON.parse(result.body)["data"]
      dc.set({id: @ids, type: "movie"}, result_parsed)
      result_parsed
    end

    private

    # :reek:InstanceVariableAssumption
    def request(ids)
      result = Faraday.get("http://localhost:3030/movies?ids=#{ids}")

      if result.status == 500
        nil
      else result
      end
    end
  end
end
