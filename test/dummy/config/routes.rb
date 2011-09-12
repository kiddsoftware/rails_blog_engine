Rails.application.routes.draw do

  mount RailsBlogEngine::Engine => "/rails_blog_engine"
end
