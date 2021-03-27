class MovieInfosController < ApplicationController
  before_action :set_movie_info, only: [:show, :update, :destroy]

  # GET /movie_infos
  def index
    @movie_infos = MovieInfo.all

    render json: @movie_infos
  end

  # GET /movie_infos/1
  def show
    render json: @movie_info
  end

  # POST /movie_infos
  def create
    @movie_info = MovieInfo.new(movie_info_params)

    if @movie_info.save
      render json: @movie_info, status: :created, location: @movie_info
    else
      render json: @movie_info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movie_infos/1
  def update
    if @movie_info.update(movie_info_params)
      render json: @movie_info
    else
      render json: @movie_info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movie_infos/1
  def destroy
    @movie_info.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie_info
      @movie_info = MovieInfo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def movie_info_params
      params.fetch(:movie_info, {})
    end
end
