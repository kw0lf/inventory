Rails.application.routes.draw do
  root 'welcome#index'
  resources :brands, except: [:show]
  resources :categories, except: [:show]

  resources :checkouts, except: [:destroy] do
    member do
      get 'checkin'
    end
  end

  resources :documents, only: [:destroy]

  resources :employees do
    member do
      get 'allocate_item'
      put 'add_item'
    end

    collection do
      get 'fetch'
    end
  end

  resources :issues, except: [:destroy] do
    member do
      put 'set_resolution'
      get 'close'
      put 'close_issue'
      put 'set_priority'
    end
  end

  resources :items do
    member do
      get 'allocate'
      put 'reallocate'
      get 'discard_reason'
      put 'discard'
      put 'remove_item'
      get 'change_parent'
      put 'update_parent'
      get 'item_render'
      get 'add_item'
      put 'add_child'
    end
  end

  resources :resolutions, except: [:show, :destroy]
  resources :users, except: [:show]
  resources :vendors, except: [:destroy]
  get "/login", to: redirect("/auth/google_oauth2")
  get "/auth/google_oauth2/callback", to: "sessions#create"
  delete 'logout', to: 'sessions#destroy'

  namespace :employee do
    resources :issues do
      member do
        put 'set_priority'
      end
    end
  end
end
