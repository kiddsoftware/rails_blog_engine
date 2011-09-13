RailsBlogEngine::Engine.routes.draw do
  root :to => 'posts#index'
  resources :posts, :except => [:index, :delete]
end
