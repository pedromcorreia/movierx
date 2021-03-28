# frozen_string_literal: true

# Adapter resposible to the module for find and create the response for the
# request
module Adapter
  # This class is a reusable class for find the response data and store in memcache
  # if the response for the Third Party API is 200, we will store the response in
  # the correct id and type
  # This descrese the response time for the client and will avoid the 500 status response
  # We use dalli to store the data in memory
  class Adapter
    require 'dalli'
    attr_accessor :query, :type, :limit, :offset

    def initialize(options = {})
      @dc = Dalli::Client.new('localhost:11211')

      @query = options[:query]
      @offset = options[:offset]
      @limit = options[:limit]
      @type = options[:type]
    end

    def call
      response_stored = find_cached_data

      return response_stored if response_stored

      result = request
      return unless result

      store_data(result)
      result
    end

    private

    def find_cached_data
      #@dc.get({ id: @query, type: @type })
    end

    def store_data(result)
      #@dc.set({ id: @query, type: @type }, result)
    end

    def request
      result = host_type.call
      if result.status == 500
        nil
      else
        JSON.parse(result.body)['data']
      end
    end

    def host_type
      case @type
      when :cast
        Adapters::Cast.new({ query: @query })
      when :genre
        Adapters::Genre.new({ query: @query, offset: @offset, limit: @limit })
      when :movie
        Adapters::Movie.new({ query: @query })
      end
    end
  end
end
