
# frozen_string_literal: true
class DiscourseShop::Coupon < ActiveRecord::Base
  self.table_name = 'discourse_shop_coupons'

  enum discount_type: { amount: 0, percent: 1 }

  validates :code, presence: true, uniqueness: true

  def active_now?
    return false if voided
    now = Time.now
    (starts_at.nil? || now >= starts_at) && (ends_at.nil? || now <= ends_at)
  end

  def discount_for_amount(subtotal_cents, currency)
    return 0 unless active_now?
    return 0 if min_subtotal_cents && subtotal_cents < min_subtotal_cents
    case discount_type
    when "amount"
      if self.currency.present? && self.currency != currency
        0 # simplistic: cross-currency not supported
      else
        [value_cents.to_i, subtotal_cents].min
      end
    when "percent"
      ((subtotal_cents * value_percent.to_i) / 100.0).floor
    else
      0
    end
  end
end
