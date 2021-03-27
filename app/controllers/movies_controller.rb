class MoviesController < ApplicationController

  def index
    if Genre.exists?(name: params['genre'].gsub('+', ' '))
      movies_info = Adapter::MovieInfoAdapter.new(genre: params['genre'], offset: params['offset'], limit: params['limit']).call

      render json: movies_info
    end
  end
end
