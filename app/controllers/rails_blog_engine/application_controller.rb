module RailsBlogEngine
  class ApplicationController < ActionController::Base
    # Use our parent application's layout, so that we "auto-blend" into
    # the existing look-and-feel of the site.
    layout 'application'

    helper_method :post_permalink_url
    helper_method :post_permalink_path

    protected

    def post_permalink_local_path(post)
      date = post.published_at.utc
      sprintf('%04d/%02d/%02d/%s', date.year, date.month,
              date.day, post.permalink)
    end

    def post_permalink_path(post)
      root_path + post_permalink_local_path(post)
    end

    def post_permalink_url(post)
      root_url + post_permalink_local_path(post)
    end
  end
end
