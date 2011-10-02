atom_feed(:root_url => root_url) do |feed|
  feed.title t('rails_blog_engine.blog.title')
  feed.updated @posts.map(&:updated_at).sort.reverse.first
  @posts.each do |post|
    feed.entry(post, :published => post.published_at) do |entry|
      entry.title post.title
    end
  end
end
