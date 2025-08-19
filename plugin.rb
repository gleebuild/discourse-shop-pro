# frozen_string_literal: true
# name: discourse-shop-pro
# about: Minimal e-commerce for Discourse with WeChat Pay (Native/H5) and coupons
# version: 0.3.1
# authors: GleeBuild + ChatGPT
# url: https://example.com/discourse-shop-pro
# required_version: 3.0.0

enabled_site_setting :shop_enabled

after_initialize do
  module ::DiscourseShopPro
    PLUGIN_NAME = "discourse-shop-pro"
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace DiscourseShopPro
    end
  end

  require_relative "lib/wechat_pay/client"

  Discourse::Application.routes.append do
    get  "/shop" => "shop#index"
    get  "/shop/products" => "shop#products"
    get  "/shop/products/:id" => "shop#show"
    post "/shop/orders" => "shop#create_order"
    post "/shop/pay" => "wechat_pay#create"
    post "/shop/wechatpay/notify" => "wechat_pay#notify"

    get  "/admin/plugins/shop" => "admin/shop_admin#index"
    get  "/admin/plugins/shop/products" => "admin/shop_admin#products"
    get  "/admin/plugins/shop/products/new" => "admin/shop_admin#new_product"
    post "/admin/plugins/shop/products" => "admin/shop_admin#create_product"
    get  "/admin/plugins/shop/products/:id/edit" => "admin/shop_admin#edit_product"
    patch "/admin/plugins/shop/products/:id" => "admin/shop_admin#update_product"
    delete "/admin/plugins/shop/products/:id" => "admin/shop_admin#destroy_product"

    get  "/admin/plugins/shop/coupons" => "admin/shop_admin#coupons"
    get  "/admin/plugins/shop/coupons/new" => "admin/shop_admin#new_coupon"
    post "/admin/plugins/shop/coupons" => "admin/shop_admin#create_coupon"
    get  "/admin/plugins/shop/coupons/:id/edit" => "admin/shop_admin#edit_coupon"
    patch "/admin/plugins/shop/coupons/:id" => "admin/shop_admin#update_coupon"
    delete "/admin/plugins/shop/coupons/:id" => "admin/shop_admin#destroy_coupon"
  end

  add_admin_route "shop.title", "shop"
end