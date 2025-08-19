# frozen_string_literal: true
class WechatPayController < ::ApplicationController
  requires_plugin ::DiscourseShopPro::PLUGIN_NAME
  skip_before_action :verify_authenticity_token, only: [:notify]
  skip_before_action :check_xhr

  def create
    render json: { error: "use /shop/orders instead" }, status: 400
  end

  def notify
    client = WechatPay::Client.new(
      mchid: SiteSetting.wechat_mch_id,
      appid: SiteSetting.wechat_appid,
      serial_no: SiteSetting.wechat_serial_no,
      api_v3_key: SiteSetting.wechat_api_v3_key,
      private_key_pem: SiteSetting.wechat_private_key_pem,
      platform_cert_pem: SiteSetting.wechat_platform_cert_pem.presence
    )

    timestamp = request.headers["Wechatpay-Timestamp"]
    nonce = request.headers["Wechatpay-Nonce"]
    signature = request.headers["Wechatpay-Signature"]
    serial = request.headers["Wechatpay-Serial"]
    body = request.raw_post

    begin
      if client.platform_cert && serial.present? && serial != client.platform_cert.serial.to_s(16).downcase
        Rails.logger.warn("Wechat serial mismatch: #{serial}")
      end
      if client.platform_cert && !client.verify_signature(signature, timestamp, nonce, body)
        Rails.logger.warn("Wechat signature verification failed")
      end

      payload = JSON.parse(body)
      resource = payload["resource"] || {}
      assoc = resource["associated_data"]
      nonce_r = resource["nonce"]
      cipher = resource["ciphertext"]
      decrypted = client.decrypt_resource(cipher, assoc, nonce_r)
      data = JSON.parse(decrypted)

      out_trade_no = data["out_trade_no"]
      transaction_id = data["transaction_id"]
      trade_state = data["trade_state"]

      order = ShopOrder.find_by(out_trade_no: out_trade_no)
      if order && trade_state == "SUCCESS"
        order.update!(status: "paid", wechat_transaction_id: transaction_id)
      end
      render json: { code: "SUCCESS", message: "OK" }
    rescue => e
      Rails.logger.error("Wechat notify error: #{e.class}: #{e.message}\n#{e.backtrace&.join("\n")}")
      render json: { code: "FAIL", message: "error" }, status: 500
    end
  end
end