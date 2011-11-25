RailsBlogEngine::Engine.routes.draw do
  # Atom feed.
  get 'posts.:format' => 'posts#index', :constraints => { :format => 'atom' }

  # Extra pages.
  get 'page/:page' => 'posts#index', :constraints => { :page => /\d+/ }

  # Home page.
  root :to => 'posts#index'

  # Public article pages.
  get(':year/:month/:day/:permalink' => 'posts#show',
      :constraints => { :year => /\d{4,}/, :month => /\d\d/, :day => /\d\d/ })

  # A regular resource interface for everything else.
  resources :posts, :except => [:index, :show, :delete]
end
