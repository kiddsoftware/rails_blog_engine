module RailsBlogEngine
  class PostsController < ApplicationController
    load_and_authorize_resource :class => "RailsBlogEngine::Post"

    def index
    end

    def new
    end

    def create
      @post.author = current_user
      if @post.save
        redirect_to(post_path(@post),
                    :notice => "Post was successfully created.")
      else
        render :action => :new
      end
    end

    def show
    end
  end
end
