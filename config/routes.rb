DialALyric::Application.routes.draw do
  resources :calls do
    post 'send', :on => :collection
  end
  resources :lyrics do
    get 'search', :on => :collection
  end
  root :to => "calls#new"
end
