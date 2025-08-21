
# frozen_string_literal: true
class DiscourseShop::Admin::CouponsController < DiscourseShop::Admin::BaseController
  def index
    scope = DiscourseShop::Coupon.order(created_at: :desc)
    scope = scope.where(code: params[:code].upcase) if params[:code].present?
    render_json_dump(coupons: scope.limit(500))
  end

  def create
    c = DiscourseShop::Coupon.create!(coupon_params)
    render_json_dump(coupon: c)
  end

  def update
    c = DiscourseShop::Coupon.find(params[:id])
    c.update!(coupon_params)
    render_json_dump(coupon: c)
  end

  def destroy
    DiscourseShop::Coupon.find(params[:id]).destroy!
    render_json_dump(success: true)
  end

  private

  def coupon_params
    params.require(:coupon).permit(:code, :discount_type, :value_cents, :value_percent, :currency, :min_subtotal_cents, :starts_at, :ends_at, :voided)
  end
end
