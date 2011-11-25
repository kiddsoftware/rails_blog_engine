module RailsBlogEngine
  module ApplicationHelper
    def markdown(md_text)
      filtered = Filters.apply_all_to(md_text)
      sanitize(RDiscount.new(filtered, :smart).to_html)
    end

    # The URL of our Atom feed. Rails refuses to generate this in any simple
    # fashion, so we do it manually.
    def feed_url
      root_url + "posts.atom"
    end
  end
end
