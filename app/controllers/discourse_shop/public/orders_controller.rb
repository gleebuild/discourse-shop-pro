
# frozen_string_literal: true
class DiscourseShop::Public::OrdersController < ::ApplicationController
  requires_plugin ::DiscourseShop::PLUGIN_NAME
  skip_before_action :check_xhr, only: [:create, :show]
  before_action :ensure_logged_in, only: [:create]

  def create
    params.require([:product_id, :quantity, :shipping, :payment_provider])
    product = DiscourseShop::Product.find(params[:product_id])
    variant = params[:variant_id].present? ? product.variants.find_by(id: params[:variant_id]) : nil
    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0

    order = DiscourseShop::Order.new(
      user: current_user,
      product: product,
      variant: variant,
      quantity: quantity,
      currency: product.currency,
      status: :pending,
      recipient_name: params[:shipping][:name],
      phone: params[:shipping][:phone],
      country: params[:shipping][:country],
      province: params[:shipping][:province],
      city: params[:shipping][:city],
      address: params[:shipping][:address],
      postal_code: params[:shipping][:postal_code]
    )
    order.recalc!

    if (code = params[:coupon_code]).present?
      coupon = DiscourseShop::Coupon.find_by(code: code.upcase)
      if coupon
        order.apply_coupon!(coupon)
      end
    end

    order.save!
    DiscourseWechatHomeLogger.log!("[shop] order created ##{order.id} by u#{current_user.id} ip=#{request.remote_ip}")

    render_json_dump(order: DiscourseShop::OrderSerializer.new(order))
  end

  def show
    order = DiscourseShop::Order.find(params[:id])
    guardian.ensure_can_see!(order.user)
    render_json_dump(order: DiscourseShop::OrderSerializer.new(order))
  end
end
