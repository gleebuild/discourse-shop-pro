
# frozen_string_literal: true
class DiscourseShop::Public::ProductsController < ::ApplicationController
  requires_plugin ::DiscourseShop::PLUGIN_NAME
  skip_before_action :check_xhr, only: [:index, :show]
  skip_before_action :redirect_to_login_if_required

  def index
    DiscourseShop::Log.log!("[shop] list products; ua=#{request.user_agent}")
    products = DiscourseShop::Product.published.order(created_at: :desc).limit(200)
    render_json_dump(products: ActiveModel::ArraySerializer.new(products, each_serializer: DiscourseShop::ProductSerializer))
  end

  def show
    product = DiscourseShop::Product.find(params[:id])
    DiscourseShop::Log.log!("[shop] show product ##{product.id}")
    raise Discourse::InvalidAccess.new unless product.active? || current_user&.admin?
    render_json_dump(product: DiscourseShop::ProductSerializer.new(product))
  end
end
