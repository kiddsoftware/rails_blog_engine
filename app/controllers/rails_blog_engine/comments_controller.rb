module RailsBlogEngine
  class CommentsController < ApplicationController
    before_filter :load_post

    def create
      @comment = @post.comments.create(params[:comment])
      if @comment.valid?
        redirect_to post_permalink_path(@post)
      else
        render "new"
      end
    end

    protected

    def load_post
      @post = Post.find(params[:post_id])
    end
  end
end
