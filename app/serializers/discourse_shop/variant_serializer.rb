
# frozen_string_literal: true
class DiscourseShop::VariantSerializer < ApplicationSerializer
  attributes :id, :name, :price_cents, :stock
end
