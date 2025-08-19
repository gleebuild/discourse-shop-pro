# frozen_string_literal: true
class ShopController < ::ApplicationController
  requires_plugin ::DiscourseShopPro::PLUGIN_NAME

  skip_before_action :check_xhr, only: [:index, :products, :show, :create_order]
  protect_from_forgery with: :exception

  def index
    redirect_to "/shop/products"
  end

  def products
    raise Discourse::NotFound unless SiteSetting.shop_enabled
    @products = ShopProduct.published.order(created_at: :desc)
    render :products
  end

  def show
    raise Discourse::NotFound unless SiteSetting.shop_enabled
    @product = ShopProduct.published.find_by!(id: params[:id]) rescue ShopProduct.published.find_by!(slug: params[:id])
    render :show
  end

  def create_order
    raise Discourse::NotFound unless SiteSetting.shop_enabled
    product = ShopProduct.published.find(params[:product_id])
    qty = (params[:quantity] || 1).to_i
    sku = params[:sku].presence
    coupon_code = params[:coupon_code].to_s.strip.upcase.presence

    unit_price_cents = product.price_cents
    discount_cents = 0
    if coupon_code
      cp = ShopCoupon.find_by(code: coupon_code)
      if cp && cp.valid_for?(product.id)
        discount_cents = [cp.amount_off_cents, unit_price_cents * qty].min
      else
        flash[:error] = "优惠券不可用"
        return redirect_to "/shop/products/#{product.id}"
      end
    end

    total_cents = unit_price_cents * qty - discount_cents
    mode = params[:mode].presence || "native"

    order = ShopOrder.create!(
      shop_product: product,
      sku: sku,
      quantity: qty,
      unit_price_cents: unit_price_cents,
      discount_cents: discount_cents,
      total_cents: total_cents,
      pay_mode: mode,
      client_ip: request.remote_ip,
      coupon_code: coupon_code
    )

    client = WechatPay::Client.new(
      mchid: SiteSetting.wechat_mch_id,
      appid: SiteSetting.wechat_appid,
      serial_no: SiteSetting.wechat_serial_no,
      api_v3_key: SiteSetting.wechat_api_v3_key,
      private_key_pem: SiteSetting.wechat_private_key_pem,
      platform_cert_pem: SiteSetting.wechat_platform_cert_pem.presence
    )

    notify_url = URI.join(SiteSetting.external_system_avatars_url.presence || Discourse.base_url, "/shop/wechatpay/notify").to_s rescue "#{Discourse.base_url}/shop/wechatpay/notify"
    body = {
      appid: client.appid,
      mchid: client.mchid,
      description: product.title[0,30],
      out_trade_no: order.out_trade_no,
      notify_url: notify_url,
      amount: { total: total_cents, currency: order.currency }
    }

    if mode == "native"
      resp = client.post("/v3/pay/transactions/native", body)
      if resp["code_url"]
        order.update!(h5_url: nil)
        @code_url = resp["code_url"]
        @order = order
        return render :pay_qr
      end
    else
      scene = { payer_client_ip: request.remote_ip, h5_info: { type: "Wap" } }
      resp = client.post("/v3/pay/transactions/h5", body.merge(scene_info: scene))
      if resp["h5_url"]
        order.update!(h5_url: resp["h5_url"])
        return redirect_to resp["h5_url"]
      end
    end

    Rails.logger.error("WeChat create order failed: #{resp.inspect}")
    flash[:error] = "创建支付失败，请稍后再试"
    redirect_to "/shop/products/#{product.id}"
  end
end