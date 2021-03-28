# frozen_string_literal: true

# Adapter resposible to the module for find and create the response for the
# request
module Adapter
  # MovieInfoAdapter is responsible to create the json view for the genre
  # arguments, find the write
  class MovieInfo
    attr_accessor :genre, :offset, :limit

    def initialize(options = {})
      @genre = options[:genre]
      @offset = options[:offset]
      @limit = options[:limit]
      @errors = []
    end

    def call
      genre_infos = Adapter.new(query: @genre, type: :genre, offset: @offset, limit: @limit).call
      infos = find_genre_infos(genre_infos)
      { infos: infos, errors: @errors }
    end

    private

    def find_genre_infos(genre_infos)
      return [] unless genre_infos

      genre_infos.map do |movie_id|
        movie_info = Adapter.new(query: movie_id, type: :movie).call
        find_movie_info(movie_info, movie_id)
      end.flatten
    end

    def find_movie_info(movie_info, movie_id)
      return put_error(movie_id, :movie) if movie_info.nil?

      movie_info.map do |movie_ids|
        cast = movie_ids['cast'].map do |cast_id|
          Adapter.new(query: cast_id, type: :cast).call
        end
        movie_json(movie_info, cast)
      end
    end

    def movie_json(movie_info, cast)
      return unless movie_info.count == 1

      info = movie_info.first
      {
        id: info['id'], title: info['title'], releaseYear: info['releaseDate'],
        revenue: info['revenue'], posterPath: info['posterPath'],
        genres: Genre.where(id: info['genres']).pluck(:name),
        cast: cast.map { |each_cast| cast_json(info, each_cast) }.reject!(&:empty?)
      }
    end

    def cast_json(movie_info, cast)
      return put_error(movie_info['id'], :cast) if cast.nil?

      cast = cast[0]
      {
        id: cast['id'],
        gender: cast['gender'],
        name: cast['name'],
        profilePath: cast['profilePath']
      }
    end

    def put_error(id, type)
      case type
      when :movie
        code = 450
        message = "Movie id ##{id} details can not be retrieved"
      when :cast
        code = 440
        message = "Movie id ##{id} cast info is not complete"
      end

      @errors.push({ "errorCode": code, "message": message })
      []
    end
  end
end
