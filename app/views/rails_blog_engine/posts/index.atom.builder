atom_feed(:root_url => blog_url, :url => feed_url) do |feed|
  feed.title t('rails_blog_engine.blog.title')
  feed.updated @posts.map(&:updated_at).sort.reverse.first
  @posts.each do |post|
    feed.entry(post, :published => post.published_at,
               :url => post_permalink_url(post)) do |entry|
      entry.title post.title
      entry.content markdown(post.body), :type => 'html'
      entry.author do |author|
        author.name post.author_byline
      end
    end
  end
end
