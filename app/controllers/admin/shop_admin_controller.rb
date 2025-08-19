# frozen_string_literal: true
class Admin::ShopAdminController < ::Admin::AdminController
  requires_plugin ::DiscourseShopPro::PLUGIN_NAME

  def index
  end

  def products
    @products = ShopProduct.order(created_at: :desc)
  end

  def new_product
    @product = ShopProduct.new(currency: SiteSetting.shop_default_currency.presence || "CNY")
  end

  def create_product
    @product = ShopProduct.new(product_params)
    if @product.save
      flash[:success] = I18n.t("shop.product_saved")
      redirect_to "/admin/plugins/shop/products"
    else
      render :new_product
    end
  end

  def edit_product
    @product = ShopProduct.find(params[:id])
  end

  def update_product
    @product = ShopProduct.find(params[:id])
    if @product.update(product_params)
      flash[:success] = I18n.t("shop.product_saved")
      redirect_to "/admin/plugins/shop/products"
    else
      render :edit_product
    end
  end

  def destroy_product
    ShopProduct.find(params[:id]).destroy
    redirect_to "/admin/plugins/shop/products"
  end

  def coupons
    @coupons = ShopCoupon.order(created_at: :desc)
  end

  def new_coupon
    @coupon = ShopCoupon.new
  end

  def create_coupon
    @coupon = ShopCoupon.new(coupon_params)
    if @coupon.save
      flash[:success] = I18n.t("shop.coupon_saved")
      redirect_to "/admin/plugins/shop/coupons"
    else
      render :new_coupon
    end
  end

  def edit_coupon
    @coupon = ShopCoupon.find(params[:id])
  end

  def update_coupon
    @coupon = ShopCoupon.find(params[:id])
    if @coupon.update(coupon_params)
      flash[:success] = I18n.t("shop.coupon_saved")
      redirect_to "/admin/plugins/shop/coupons"
    else
      render :edit_coupon
    end
  end

  def destroy_coupon
    ShopCoupon.find(params[:id]).destroy
    redirect_to "/admin/plugins/shop/coupons"
  end

  private

  def product_params
    p = params.require(:shop_product).permit(:title, :slug, :description, :price_cents, :currency, :image_url, :stock, :published, :specs_json)
    if p[:specs_json].present?
      p[:specs] = JSON.parse(p.delete(:specs_json)) rescue []
    end
    p.except(:specs_json)
  end

  def coupon_params
    params.require(:shop_coupon).permit(:code, :amount_off_cents, :expires_at, :usage_limit, :active, :shop_product_id)
  end
end