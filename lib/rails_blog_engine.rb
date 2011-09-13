# Manually require gems, because Bundler won't auto-require them when we're
# running inside a gem.
require "jquery-rails"
require "haml"
require "simple_form"

require "rails_blog_engine/engine"
require "rails_blog_engine/ability"

module RailsBlogEngine
end
