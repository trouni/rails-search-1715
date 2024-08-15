class MoviesController < ApplicationController
  def index
    @movies =
      if params[:q].present?
        Movie.search(params[:q])
      else
        Movie.all
      end
  end
end
