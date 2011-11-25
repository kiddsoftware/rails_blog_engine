# Configure RailsBlogEngine here.

# If you want to activate the built-in spam filter, visit http://akismet.com/
# and sign up for an API key.
Rails.application.config.rakismet.key = ENV['RAKISMET_KEY']

# The URL of your blog, for use by Akismet's spam filter.
Rails.application.config.rakismet.url = ENV['RAKISMET_URL']

# Disable the Akismet middleware, because it isn't needed by
# rails_blog_engine.  If you use Akismet elsewhere in your application, you
# may to set this back to true.
Rails.application.config.rakismet.use_middleware = false
