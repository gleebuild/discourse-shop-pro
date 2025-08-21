
# frozen_string_literal: true
module DiscourseShop
  class Engine < ::Rails::Engine
    engine_name 'discourse_shop'
    isolate_namespace DiscourseShop
  end
end

DiscourseShop::Engine.routes.draw do
  namespace :public do
    resources :products, only: [:index, :show]
    post 'checkout' => 'orders#create'
    post 'pay' => 'payments#create'
    get  'orders/:id' => 'orders#show'
  end

  namespace :admin do
    resources :products do
      resources :variants, only: [:create, :update, :destroy]
      member do
        post :publish
        post :unpublish
      end
    end
    resources :coupons
    resources :orders do
      member do
        post :mark_paid
        post :ship
      end
    end
    post 'uploads' => 'uploads#create'
  end
end
