DialALyric::Application.routes.draw do
  resources :calls, :only => [:new, :create, :show] do
    post 'initiate', :on => :collection
  end
  resources :lyrics, :only => [:show] do
    get 'search', :on => :collection
  end
  root :to => "lyrics#search"
end
