
# frozen_string_literal: true
class DiscourseShop::Variant < ActiveRecord::Base
  self.table_name = 'discourse_shop_variants'

  belongs_to :product, class_name: 'DiscourseShop::Product'

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
end
