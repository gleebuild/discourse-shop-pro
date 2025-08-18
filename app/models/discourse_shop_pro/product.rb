# frozen_string_literal: true
module ::DiscourseShopPro
  class Product < ::ActiveRecord::Base
    self.table_name = "shop_products"
    # JSONB columns are native; serialize guards older AR
    if respond_to?(:serialize)
      serialize :images, JSON
      serialize :specs, JSON
    end
    validates :title, presence: true
  end
end
