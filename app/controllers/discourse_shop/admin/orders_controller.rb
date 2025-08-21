
# frozen_string_literal: true
class DiscourseShop::Admin::OrdersController < DiscourseShop::Admin::BaseController
  def index
    scope = DiscourseShop::Order.order(created_at: :desc)
    scope = scope.where(status: DiscourseShop::Order.statuses[params[:status]]) if params[:status].present?
    render_json_dump(orders: ActiveModel::ArraySerializer.new(scope.limit(500), each_serializer: DiscourseShop::OrderSerializer))
  end

  def mark_paid
    o = DiscourseShop::Order.find(params[:id])
    o.update!(status: :paid, paid_at: Time.now)
    render_json_dump(order: DiscourseShop::OrderSerializer.new(o))
  end

  def ship
    o = DiscourseShop::Order.find(params[:id])
    o.update!(status: :shipped, shipping_company: params[:shipping_company], tracking_number: params[:tracking_number], shipped_at: Time.now)
    render_json_dump(order: DiscourseShop::OrderSerializer.new(o))
  end
end
