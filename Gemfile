source "http://rubygems.org"

# Declare your gem's dependencies in rails_blog_engine.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  # We need a version which doesn't create objects in separate threads,
  # cache them, or do anything else that breaks database-cleaning
  # transactions in Steak.
  gem 'machinist', :git => 'https://github.com/notahat/machinist.git'

  # This is an optional runtime depedency.
  gem 'pygments', :git => 'https://github.com/nathany/pygments-gem.git'
end
