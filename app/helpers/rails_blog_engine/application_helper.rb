module RailsBlogEngine
  module ApplicationHelper
    # Process a block of text as Markdown, using our filters, and sanitize
    # any usafe HTML.  You can pass <code>:trusted => true</code> to allow
    # images and links without nofollow.
    def markdown(md_text, options={})
      config = sanitize_config(options[:trusted] || false)
      filtered = Filters.apply_all_to(md_text)
      Sanitize.clean(RDiscount.new(filtered, :smart).to_html, config).html_safe
    end

    # The URL of our Atom feed. Rails refuses to generate this in any simple
    # fashion, so we do it manually.
    def feed_url
      root_url + "posts.atom"
    end

    protected

    # Choose a configuration for the Sanitizer gem.
    def sanitize_config(trusted)
      if trusted
        Sanitize::Config::RELAXED
      else
        Sanitize::Config::BASIC
      end
    end
  end
end
