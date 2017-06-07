Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :products do
      member do
        get :filter_by_category
      end
    end
    resources :orders
    resources :product_categories
  end
  resources :products do
    member do
      post :add_to_cart
      post :buy_immediately
      get :filter_by_category
      post :favorite
    end
    collection do
      match 'search' => 'products#search', via: [:get, :post], as: :search
    end
  end

  resources :carts do
    member do
      post :clear
      post :remove_product
      post :remove_immediately_product
      post :increase_product
      post :decrease_product
    end

    collection do
      post :checkout
    end
  end

  resources :orders do
    member do
      post :pay_with_ailipay
      post :pay_with_wechat
      post :pay
      post :cancel
      post :ship
    end
    collection do
      match 'pay_method' => 'orders#pay_method', via: [:get, :post], as: :pay_method
    end
  end

  resources :favorites,:reviews

  resources :addresses do
    collection do
      get :address_list
    end

    member do
      post :set_default
    end
  end

  resources :usercenter do

    collection do
      match 'order' => 'usercenter#order', via: [:get, :post], as: :order
      match 'address' => 'usercenter#address', via: [:get, :post], as: :address
      match 'personal' => 'usercenter#personal', via: [:get, :post], as: :personal
      match 'category' => 'usercenter#category', via: [:get, :post], as: :category
      match 'favorite' => 'usercenter#favorite', via: [:get, :post], as: :favorite
    end

  end



  # match 'usercenter/order' => 'usercenter#order', :via => :get
  # match 'usercenter/address' => 'usercenter#address', :via => :get
  # match 'usercenter/personal' => 'usercenter#personal', :via => :get


  root "products#index"
end
