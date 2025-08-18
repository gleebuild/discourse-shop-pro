# frozen_string_literal: true
require_dependency "application_controller"
require "ostruct"

module ::DiscourseShopPro
  module Public
    class ProductsController < ::ApplicationController
      requires_plugin ::DiscourseShopPro::PLUGIN_NAME

      # Make these pages public
      skip_before_action :ensure_logged_in, raise: false
      skip_before_action :redirect_to_login_if_required, raise: false
      skip_before_action :check_xhr, raise: false
      skip_before_action :preload_json, raise: false
      skip_before_action :verify_authenticity_token, raise: false

      def index
        products = load_products
        respond_to do |format|
          format.html do
            @products = products
            render :index, layout: "no_ember"
          end
          format.json { render json: products }
        end
      end

      def show
        products = load_products
        id = params[:id].to_s
        product = products.find { |p| p[:id].to_s == id }
        respond_to do |format|
          format.html do
            @product = OpenStruct.new(product || { id: id, title: "未找到商品", price_cents: 0, images: [] })
            render :show, layout: "no_ember"
          end
          format.json do
            if product
              render json: product
            else
              render json: { error: "not found" }, status: 404
            end
          end
        end
      end

      private

      def load_products
        if defined?(::DiscourseShopPro::Product) && ::DiscourseShopPro::Product.table_exists?
          records = ::DiscourseShopPro::Product.where(on_sale: true).order(created_at: :desc).limit(200)
          records.map do |p|
            { id: p.id, title: p.title, images: (p.images || []), price_cents: p.price_cents.to_i }
          end
        else
          demo_products
        end
      rescue => e
        Rails.logger.warn("[shop_pro] load_products fallback due to: #{e.class}: #{e.message}")
        demo_products
      end

      def demo_products
        [
          { id: 1, title: "Demo Hoodie", images: [], price_cents: 5999 },
          { id: 2, title: "Demo Mug", images: [], price_cents: 1999 }
        ]
      end
    end
  end
end
