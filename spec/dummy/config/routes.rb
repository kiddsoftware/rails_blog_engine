Rails.application.routes.draw do
  mount RailsBlogEngine::Engine => "/blog"
end
