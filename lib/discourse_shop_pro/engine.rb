# frozen_string_literal: true
require "rails"

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
  # Lightweight healthcheck that never hits Rails controllers
  get "/_health", to: proc { [200, { "Content-Type" => "application/json" }, ['{"ok":true}']] }

  root to: "public/products#index"
  get "/public/products" => "public/products#index"
  get "/public/products/:id" => "public/products#show"
  get "/public/products/:id.json" => "public/products#show", defaults: { format: :json }
end
