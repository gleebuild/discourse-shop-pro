
# frozen_string_literal: true
class DiscourseShop::Order < ActiveRecord::Base
  self.table_name = 'discourse_shop_orders'

  belongs_to :user
  belongs_to :product, class_name: 'DiscourseShop::Product'
  belongs_to :variant, class_name: 'DiscourseShop::Variant', optional: true
  belongs_to :coupon, class_name: 'DiscourseShop::Coupon', optional: true

  enum status: { pending: 0, paid: 1, shipped: 2, completed: 3, cancelled: 4 }

  validates :currency, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  def recalc!
    self.subtotal_cents = (variant&.price_cents || product.price_cents) * quantity
    self.discount_cents ||= 0
    self.total_cents = [subtotal_cents - discount_cents, 0].max
  end

  def apply_coupon!(coupon)
    self.coupon = coupon
    dc = coupon.discount_for_amount(subtotal_cents, currency)
    self.discount_cents = dc
    recalc!
  end
end
