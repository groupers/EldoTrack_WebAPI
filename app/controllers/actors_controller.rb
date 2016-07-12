class ActorsController < ApplicationController
  def index
    actors = Actor.all
    api_response(actors)
  end
end
