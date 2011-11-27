module RailsBlogEngine
  class PostsController < RailsBlogEngine::ApplicationController
    before_filter :load_recently_published, :only => :index
    before_filter :load_by_permalink, :only => :show

    load_and_authorize_resource :class => "RailsBlogEngine::Post"

    def index
      respond_to do |format|
        format.html { @posts = @posts.page(params[:page]).per(5) }
        format.atom { @posts = @posts.limit(15) }
      end
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
      @comments = comments_to_display.order(:created_at)
      @comment = Comment.new {|c| c.post = @post }
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

    def load_recently_published
      @posts = Post.recently_published
    end

    def load_by_permalink
      date = Time.utc(params[:year], params[:month], params[:day])
      @post = Post.where(:published_at => (date..date.end_of_day),
                         :permalink => params[:permalink]).first!
    end

    def comments_to_display
      if can?(:update, RailsBlogEngine::Comment)
        @post.comments
      else
        @post.comments.visible
      end
    end
  end
end
