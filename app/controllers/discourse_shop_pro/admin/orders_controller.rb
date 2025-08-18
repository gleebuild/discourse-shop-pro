# frozen_string_literal: true
require_dependency "application_controller"

module ::DiscourseShopPro
  module Admin
    class OrdersController < ::Admin::AdminController
      requires_plugin ::DiscourseShopPro::PLUGIN_NAME

      def index
        render json: { ok: true, orders: [] }
      end

      def ship
        render json: { ok: true, id: params[:id] }
      end
    end
  end
end
