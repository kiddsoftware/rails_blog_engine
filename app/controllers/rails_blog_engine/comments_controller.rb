module RailsBlogEngine
  class CommentsController < ApplicationController
    before_filter :load_post

    def create
      # Record some extra information from our environment.  Most of this
      # is used by the spam filter.
      comment_attrs = params[:comment].merge({
        :author_ip => request.remote_ip,
        :author_user_agent => request.env['HTTP_USER_AGENT'],
        :referrer => request.env['HTTP_REFERER'],
        :author_can_post => can?(:create, RailsBlogEngine::Post)
      })

      @comment = @post.comments.create(comment_attrs)
      if @comment.valid?
        @comment.run_spam_filter
        if @comment.filtered_as_spam?
          flash[:comment_notice] = "Your comment has been held for moderation."
          redirect_to(post_permalink_path(@post) + '#comment-flash')
        else
          redirect_to(post_permalink_path(@post) + "#comment-#{@comment.id}")
        end
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
