
# frozen_string_literal: true
class DiscourseShop::Product < ActiveRecord::Base
  self.table_name = 'discourse_shop_products'

  has_many :variants, class_name: 'DiscourseShop::Variant', dependent: :destroy
  has_many :orders, class_name: 'DiscourseShop::Order'

  enum status: { draft: 0, active: 1, archived: 2 }

  validates :title, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true

  scope :published, -> { where(status: DiscourseShop::Product.statuses[:active]) }

  def image_url
    self[:image_url]
  end
end


  after_create  { ::DiscourseShop::Log.log!("[#{rel}] CREATE id=#{id}") }
  after_update  { ::DiscourseShop::Log.log!("[#{rel}] UPDATE id=#{id}") }
  after_destroy { ::DiscourseShop::Log.log!("[#{rel}] DESTROY id=#{id}") }
