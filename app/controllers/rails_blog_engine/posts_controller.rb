module RailsBlogEngine
  class PostsController < ApplicationController
    load_and_authorize_resource :class => "RailsBlogEngine::Post"

    def index
    end
  end
end
