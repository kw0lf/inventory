Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users, :controllers => { :registrations => "user/registrations" }
  resources :items
  resources :categories, except: [:destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
