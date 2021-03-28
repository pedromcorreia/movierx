# frozen_string_literal: true

class MoviesController < ApplicationController # rubocop:todo Style/Documentation
  def index
    if Genre.exists?(name: params['genre'].gsub('+', ' '))
      offset = params['offset'] || 0
      limit = params['limit'] || 10

      result = Adapter::MovieInfoAdapter.new(genre: params['genre'],
                                             offset: offset, limit: limit).call

      render json: movies_info_j(result, offset, limit)
    else
      render json: { errors: 'invalid genre' }, status: :unprocessable_entity
    end
  end

  private

  def movies_info_j(result, offset, limit)
    {
      data: { movies: result[:infos] },
      metadata: {
        offset: offset,
        limit: limit,
        total: result[:infos].count
      },
      errors: result[:errors].uniq
    }
  end
end
