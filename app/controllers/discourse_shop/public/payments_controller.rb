
# frozen_string_literal: true
class DiscourseShop::Public::PaymentsController < ::ApplicationController
  requires_plugin ::DiscourseShop::PLUGIN_NAME
  skip_before_action :check_xhr
  before_action :ensure_logged_in

  def create
    params.require([:order_id, :payment_provider])
    order = DiscourseShop::Order.find(params[:order_id])
    guardian.ensure_can_see!(order.user)

    provider = params[:payment_provider].to_s
    impl = DiscourseShop::PaymentGateway.resolve(provider) || DiscourseShop::PaymentGateway.resolve('sandbox')
    return_url = "#{Discourse.base_url}/shop/complete?order_id=#{order.id}"
    notify_url = "#{Discourse.base_url}/shop/payment_notify/#{provider}"

    DiscourseWechatHomeLogger.log!("[shop] start pay order ##{order.id} provider=#{provider}")

    result = impl.create_payment(order: order, return_url: return_url, notify_url: notify_url, ip: request.remote_ip, ua: request.user_agent)

    render_json_dump(payment: { provider: result.provider, url: result.pay_url, payload: result.payload })
  end
end
