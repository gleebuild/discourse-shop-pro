# frozen_string_literal: true
class ShopOrder < ActiveRecord::Base
  self.table_name = "shop_orders"
  belongs_to :shop_product
  enum status: { pending: "pending", paid: "paid", failed: "failed", closed: "closed" }

  before_validation do
    self.currency ||= SiteSetting.shop_default_currency.presence || "CNY"
    self.out_trade_no ||= SecureRandom.hex(12)
  end
end