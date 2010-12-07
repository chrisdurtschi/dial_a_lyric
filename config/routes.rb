DialALyric::Application.routes.draw do
  resources :calls do
    post 'initiate', :on => :collection
  end
  resources :lyrics do
    get 'search', :on => :collection
  end
  root :to => "lyrics#search"
end
