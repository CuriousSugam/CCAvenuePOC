Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'payments#index'
  resources :payments do
    collection do
      post 'pay'
      post 'ccavResponseHandler'
      post 'ccavRequestHandler'
      get 'sample'
    end
  end

  get '/success', to: 'payments#success'
  # post '/success', to: 'payments#success'

  get '/test-redirect', to: 'payments#test_redirect'
end
