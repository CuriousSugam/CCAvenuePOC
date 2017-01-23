Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'payment#index'
  resources :payment do
    collection do
      post 'ccavResponseHandler'
      post 'ccavRequestHandler'
      get 'sample'
    end
  end
end
