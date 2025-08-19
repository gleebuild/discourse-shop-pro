# frozen_string_literal: true
class ShopCoupon < ActiveRecord::Base
  self.table_name = "shop_coupons"
  belongs_to :shop_product, optional: true
  validates :code, presence: true, uniqueness: true

  def valid_for?(product_id)
    active && (expires_at.nil? || expires_at > Time.now) && (shop_product_id.nil? || shop_product_id == product_id) && (usage_limit.nil? || times_used < usage_limit)
  end
end