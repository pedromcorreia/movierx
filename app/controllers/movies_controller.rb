# frozen_string_literal: true

class MoviesController < ApplicationController # rubocop:todo Style/Documentation
  before_action :require_correct_genre, :require_valid_params

  def index
    offset = params['offset'] || 0
    limit = params['limit'] || 10

    result = Adapter::MovieInfo.new(genre: params['genre'],
                                    offset: offset, limit: limit).call

    render json: movies_info_j(result, offset, limit)
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

  def require_correct_genre
    return if Genre.exists?(name: params['genre'].gsub('+', ' '))

    render json: { errors: 'invalid genre' }, status: :unprocessable_entity
  end

  def require_valid_params
    return if params['limit'].to_i.positive? && params['offset'].to_i >= 0

    render json: { errors: 'limit or offset must be positive' }, status: :unprocessable_entity
  end
end
