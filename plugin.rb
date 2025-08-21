
# frozen_string_literal: true
# name: discourse-shop-pro
# about: Full-featured Shop (products, variants, coupons, orders) with pluggable payment gateways (WeChat / PayPal via add-on plugins)
# version: 1.0.0-20250821
# authors: GleeBuild + ChatGPT
# required_version: 3.0.0
# url: https://lebanx.com

enabled_site_setting :shop_enabled

register_asset 'stylesheets/common/discourse-shop.scss'

after_initialize do
  module ::DiscourseShop
    PLUGIN_NAME = "discourse-shop-pro"
  end

  # ---- 1) 统一日志工具（写文件到 /var/www/discourse/public/wechat.txt）----
  module ::DiscourseWechatHomeLogger
    LOG_DIR  = "/var/www/discourse/public"
    LOG_FILE = File.join(LOG_DIR, "wechat.txt")
    HOMEPATHS = ['/', '/latest', '/categories', '/top', '/new', '/hot'].freeze

    def self.log!(message)
      begin
        FileUtils.mkdir_p(LOG_DIR) unless Dir.exist?(LOG_DIR)
        timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S %z")
        File.open(LOG_FILE, "a") { |f| f.puts("#{timestamp} | #{message}") }
      rescue => e
        Rails.logger.warn("[wechat-home-logger] write error: #{e.class}: #{e.message}")
      end
    end
  end

  require_relative 'lib/discourse_shop/engine'
  require_relative 'lib/discourse_shop/payment_gateway'

  # Mount our engine
  Discourse::Application.routes.append do
    mount ::DiscourseShop::Engine, at: '/shop'
  end
end
