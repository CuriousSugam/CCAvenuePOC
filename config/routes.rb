Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'payment#index'
  resources :payment do
    collection do
      post 'pay'
      post 'ccavResponseHandler'
      post 'ccavRequestHandler'
      get 'sample'
    end
  end

  get '/success', to: 'payment#success'
  # post '/success', to: 'payment#success'

  get '/test-redirect', to: 'payment#test_redirect'
end
