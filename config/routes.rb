Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'isps/login', to: 'isps#login'

  put 'isps/:id/change_password', to: 'isps#change_password'

  get 'services', to: 'services#index'

  get 'isps/:id/list_request',to: 'isps#list_request'

  get 'isps/:id/reject_request',to: 'isps#list_rejected'

  put 'isps/:isp_id/services/:id/user_service/:user_service_id/check_request', to: 'services#check_request'

  resources :isps, except:[:new,:edit] do
    post 'services/:id/request', to: 'services#request_service'
    resources :services, except:[:index,:new,:edit]
  end

  get 'users/login', to: 'users#login'

  put 'users/:id/change_password', to: 'users#change_password'

  resources :users, except:[:index,:new,:edit,:destroy]

end
