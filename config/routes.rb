Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :isps, except:[:new,:edit] do
    resources :services, except:[:index,:new,:edit]
  end

  get 'services', to: 'services#index'

  resources :users, except:[:index,:new,:edit,:destroy]

end
