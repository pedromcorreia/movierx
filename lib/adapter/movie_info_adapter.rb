# frozen_string_literal: true

# TODO: add here a good description
module Adapter
  class MovieInfoAdapter
    require 'dalli'

    def initialize(genre:, offset:, limit:)
      @genre = genre
      @offset = offset
      @limit = limit
      @errors = []
    end

    def call
      movies_ids = Adapter.new(query: @genre, type: "genre", offset: @offset, limit: @limit).call
      json = movies_ids.map do |movie_id|
        movie_info = Adapter.new(query: movie_id, type: "movie").call

        if movie_info.nil?
          put_error(movie_id, "movie")
        else
          movie_info.map do |movie_ids|
            cast = movie_ids['cast'].map do |cast_id|
              Adapter.new(query: cast_id, type: "cast").call
            end
            movie_view(movie_info, cast)
          end
        end
      end
      view(json)
    end

    private
    def put_error(id, type)
      if type == "movie"
        @errors.push({
          "errorCode": 450,
          "message": "Movie id ##{id} details can not be retrieved"
        })
      else
        @errors.push({
          "errorCode": 440,
          "message": "Movie id ##{id} cast info is not complete"
        })

      end
    end
    def view(json)
      {
        data: {
          movies: json
        },
        "metadata": {
          "offset": @offset,
          "limit": @limit,
          "total": json.count
        },
        "errors": @errors.uniq
      }
    end

    def movie_view(movie_info, cast)
      if movie_info.count == 1
        movie_info=movie_info[0]
        {
          'id': movie_info['id'],
          'title': movie_info['title'],
          'releaseYear': movie_info['releaseDate'],
          'revenue': movie_info['revenue'],
          'posterPath': movie_info['posterPath'],
          'genres': Genre.where(id: movie_info["genres"]).pluck(:name),
          'cast': cast.map {|each_cast| cast_view(movie_info, each_cast)}
        }
      end
    end

    def cast_view(movie_info, cast)
      if cast
        cast = cast[0]
        {
          'id': cast['id'],
          'gender': cast['gender'],
          'name': cast['name'],
          'profilePath': cast['profilePath']
        }
      else
        put_error(movie_info['id'], "cast")
        []
      end
    end
  end
end
