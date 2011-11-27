module RailsBlogEngine
  module PostsHelper
    # Link to the comments section of a post.
    def link_to_comments_section(post)
      if post.comments.visible.empty?
        link_to("Comment", post_permalink_path(post) + "#comments")
      else
        link_to(pluralize(post.comments.visible.count, 'comment'),
                post_permalink_path(post) + "#comments")
      end
    end
  end
end
