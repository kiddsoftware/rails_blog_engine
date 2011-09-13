Rails.application.routes.draw do
  devise_for :users
  root :to => 'home#index'

  mount RailsBlogEngine::Engine => "/blog"
end
