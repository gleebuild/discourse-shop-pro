
# frozen_string_literal: true
class DiscourseShop::Admin::ProductsController < DiscourseShop::Admin::BaseController
  def index
    scope = DiscourseShop::Product.order(created_at: :desc)
    scope = scope.where(status: DiscourseShop::Product.statuses[params[:status]]) if params[:status].present?
    render_json_dump(products: ActiveModel::ArraySerializer.new(scope.limit(500), each_serializer: DiscourseShop::ProductSerializer))
  end

  def create
    p = DiscourseShop::Product.new(product_params)
    p.status = :draft if p.status.nil?
    p.save!
    render_json_dump(product: DiscourseShop::ProductSerializer.new(p))
  end

  def update
    p = DiscourseShop::Product.find(params[:id])
    p.update!(product_params)
    render_json_dump(product: DiscourseShop::ProductSerializer.new(p))
  end

  def destroy
    DiscourseShop::Product.find(params[:id]).destroy!
    render_json_dump(success: true)
  end

  def publish
    p = DiscourseShop::Product.find(params[:id])
    p.update!(status: :active)
    render_json_dump(success: true)
  end

  def unpublish
    p = DiscourseShop::Product.find(params[:id])
    p.update!(status: :draft)
    render_json_dump(success: true)
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price_cents, :currency, :image_url, :stock, :status)
  end
end
