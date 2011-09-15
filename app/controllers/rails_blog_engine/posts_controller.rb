module RailsBlogEngine
  class PostsController < ApplicationController
    before_filter :load_by_permalink, :only => :show

    load_and_authorize_resource :class => "RailsBlogEngine::Post"
    skip_load_resource :only => :show

    def index
    end

    def new
    end

    def create
      @post.author = current_user
      @post.publish
      if @post.save
        redirect_to(post_permalink_path(@post),
                    :notice => "Post was successfully created.")
      else
        render :action => :new
      end
    end

    def show
    end

    def edit
    end

    def update
      @post.update_attributes(params[:post])
      if @post.save
        redirect_to(post_permalink_path(@post),
                    :notice => "Post was successfully updated.")
      else
        render :action => :edit
      end
    end

    protected

    def post_permalink_path(post)
      date = post.published_at.utc
      local_path = sprintf('%04d/%02d/%02d/%s', date.year, date.month,
                           date.day, post.permalink)
      root_path + local_path
    end

    def load_by_permalink
      date = Time.utc(params[:year], params[:month], params[:day])
      @post = Post.where(:published_at => (date..date.end_of_day),
                         :permalink => params[:permalink]).first!
    end
  end
end
