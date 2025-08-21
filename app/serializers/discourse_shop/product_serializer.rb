
# frozen_string_literal: true
class DiscourseShop::ProductSerializer < ApplicationSerializer
  attributes :id, :title, :description, :price_cents, :currency, :status, :image_url, :stock, :created_at, :updated_at

  has_many :variants, serializer: DiscourseShop::VariantSerializer
end
