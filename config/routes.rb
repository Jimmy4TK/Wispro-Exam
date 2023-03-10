Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post 'isps/login', to: 'isps#login'

  put 'isps/:id/change_password', to: 'isps#change_password'

  get 'services', to: 'services#index'

  get 'isps/:isp_id/user_services/list_request',to: 'user_services#list_request'

  get 'isps/:isp_id/user_services/reject_request',to: 'user_services#list_rejected'

  put 'isps/:isp_id/services/:service_id/user_services/:id/check_request', to: 'user_services#check_request'

  post 'isps/:isp_id/services/:service_id/user_services', to: 'user_services#create'

  resources :isps, except:[:new,:edit] do
    resources :services, except:[:index,:new,:edit]
  end

  post 'users/login', to: 'users#login'

  put 'users/:id/change_password', to: 'users#change_password'

  resources :users, except:[:index,:new,:edit,:destroy]

end
