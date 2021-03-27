require 'test_helper'

class MovieInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie_info = movie_infos(:one)
  end

  test "should get index" do
    get movie_infos_url, as: :json
    assert_response :success
  end

  test "should create movie_info" do
    assert_difference('MovieInfo.count') do
      post movie_infos_url, params: { movie_info: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show movie_info" do
    get movie_info_url(@movie_info), as: :json
    assert_response :success
  end

  test "should update movie_info" do
    patch movie_info_url(@movie_info), params: { movie_info: {  } }, as: :json
    assert_response 200
  end

  test "should destroy movie_info" do
    assert_difference('MovieInfo.count', -1) do
      delete movie_info_url(@movie_info), as: :json
    end

    assert_response 204
  end
end
