# frozen_string_literal: true

module Adapter
  # TODO: add here a good description
  class CastAdapter

    require 'dalli'

    def initialize(id:)
      @id = id
    end

    def call
      dc = Dalli::Client.new('localhost:11211')

      value = dc.get({id: @id, type: "cast"})

      return value if value

      result = request(@id)
      return unless result

      result_parsed = JSON.parse(result.body)['data']

      dc.set({id: @id, type: "cast"}, result_parsed)
      result_parsed
    end

    private

    # :reek:InstanceVariableAssumption
    def request(id)
      result = Faraday.get("http://localhost:3050/artists?ids=#{id}")
      if result.status == 500
        nil
      else
        result
      end
    end
  end
end
