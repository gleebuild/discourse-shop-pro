# frozen_string_literal: true
module ::DiscourseShopPro
  class Engine < ::Rails::Engine
    engine_name ::DiscourseShopPro::PLUGIN_NAME
    isolate_namespace ::DiscourseShopPro
  end
end

Discourse::Application.routes.append do
  mount ::DiscourseShopPro::Engine, at: "/shop"
end

::DiscourseShopPro::Engine.routes.draw do
  # Rack-only health for quick verification even if controllers fail
  get "/_health", to: proc { |_env| [200, {"Content-Type"=>"application/json"}, ['{"ok":true}']] }

  root to: "public/products#index"
  get "/public/products" => "public/products#index"
  get "/public/products/:id" => "public/products#show"
  get "/public/products/:id.json" => "public/products#show"

  namespace :admin do
    get "/orders" => "orders#index"
    post "/orders/:id/ship" => "orders#ship"
  end

  post "/logistics/kd100/notify" => "logistics#kd100_notify"
end
