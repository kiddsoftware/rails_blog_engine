RailsBlogEngine::Engine.routes.draw do
  root :to => 'posts#index'

  get(':year/:month/:day/:permalink' => 'posts#show',
      :constraints => { :year => /\d{4,}/, :month => /\d\d/, :day => /\d\d/ })

  resources :posts, :except => [:index, :show, :delete]
end
