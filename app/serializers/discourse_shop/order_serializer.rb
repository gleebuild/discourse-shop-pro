
# frozen_string_literal: true
class DiscourseShop::OrderSerializer < ApplicationSerializer
  attributes :id, :status, :product_id, :variant_id, :quantity,
             :subtotal_cents, :discount_cents, :total_cents, :currency,
             :recipient_name, :phone, :country, :province, :city, :address, :postal_code,
             :shipping_company, :tracking_number,
             :payment_provider, :payment_id, :created_at, :updated_at
end
