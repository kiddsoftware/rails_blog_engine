# Manually require gems, because Bundler won't auto-require them when we're
# running inside a gem.
require "state_machine"
require "jquery-rails"
require "haml"
require "rdiscount"
require "simple_form"
require "kaminari"
require "rakismet"

require "rails_blog_engine/engine"
require "rails_blog_engine/ability"
require "rails_blog_engine/filters"

module RailsBlogEngine
end
