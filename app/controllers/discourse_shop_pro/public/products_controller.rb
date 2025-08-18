# frozen_string_literal: true
require_dependency "application_controller"

module ::DiscourseShopPro
  module Public
    class ProductsController < ::ApplicationController
      requires_plugin ::DiscourseShopPro::PLUGIN_NAME

      # Public pages: allow access without login/XHR
      skip_before_action :ensure_logged_in, raise: false
      skip_before_action :redirect_to_login_if_required, raise: false
      skip_before_action :check_xhr, raise: false
      skip_before_action :preload_json, raise: false
      skip_before_action :verify_authenticity_token, raise: false

      def index
        @products = demo_products
        respond_to do |format|
          format.html { render :index, layout: "no_ember" }
          format.json { render json: @products }
        end
      end

      def show
        product = demo_products.find { |p| p[:id].to_s == params[:id].to_s } || demo_products.first
        respond_to do |format|
          format.html do
            @product = product
            render :show, layout: "no_ember"
          end
          format.json { render json: product }
        end
      end

      private

      def demo_products
        [
          {
            id: 1,
            title: "Demo Hoodie",
            images: [helpers.asset_path("images/discourse-logo-sketch.png")],
            price_cents: 3999,
            specs: [{ "price_cents" => 3999 }]
          },
          {
            id: 2,
            title: "Demo Mug",
            images: [helpers.asset_path("images/discourse-logo-sketch.png")],
            price_cents: 1299,
            specs: [{ "price_cents" => 1299 }]
          }
        ]
      end
    end
  end
end
