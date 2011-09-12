module RailsBlogEngine
  class PostsController < ApplicationController
    def index
      @posts = Post.all
    end
  end
end
