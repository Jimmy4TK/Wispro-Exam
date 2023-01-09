Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'isps/login', to: 'isps#login'

  put 'isps/change_password', to: 'isps#change_password'

  resources :isps, except:[:new,:edit] do
    resources :services, except:[:index,:new,:edit]
  end

  get 'services', to: 'services#index'

  get 'users/login', to: 'users#login'

  put 'users/:id/change_password', to: 'users#change_password'

  resources :users, except:[:index,:new,:edit,:destroy]

end
