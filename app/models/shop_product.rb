# frozen_string_literal: true
class ShopProduct < ActiveRecord::Base
  self.table_name = "shop_products"
  validates :title, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  scope :published, -> { where(published: true) }

  def price_money
    (price_cents || 0) / 100.0
  end

  def to_param
    slug.presence || id.to_s
  end
end