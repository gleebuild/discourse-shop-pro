
# frozen_string_literal: true
class CreateShopTables < ActiveRecord::Migration[7.0]
  def change
    create_table :discourse_shop_products do |t|
      t.string  :title, null: false
      t.text    :description
      t.integer :price_cents, null: false, default: 0
      t.string  :currency, null: false, default: 'CNY'
      t.integer :status, null: false, default: 0
      t.string  :image_url
      t.integer :stock, null: false, default: 999999
      t.timestamps
    end

    create_table :discourse_shop_variants do |t|
      t.integer :product_id, null: false
      t.string  :name, null: false
      t.integer :price_cents, null: false, default: 0
      t.integer :stock, null: false, default: 999999
      t.timestamps
    end
    add_index :discourse_shop_variants, :product_id

    create_table :discourse_shop_coupons do |t|
      t.string  :code, null: false
      t.integer :discount_type, null: false, default: 0 # 0 amount, 1 percent
      t.integer :value_cents
      t.integer :value_percent
      t.string  :currency
      t.integer :min_subtotal_cents
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :voided, null: false, default: false
      t.timestamps
    end
    add_index :discourse_shop_coupons, :code, unique: true

    create_table :discourse_shop_orders do |t|
      t.integer :user_id, null: false
      t.integer :product_id, null: false
      t.integer :variant_id
      t.integer :quantity, null: false, default: 1

      t.integer :subtotal_cents, null: false, default: 0
      t.integer :discount_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.string  :currency, null: false, default: 'CNY'

      t.integer :status, null: false, default: 0 # pending, paid, shipped, completed, cancelled

      t.integer :coupon_id
      t.string  :payment_provider
      t.string  :payment_id

      t.string :recipient_name
      t.string :phone
      t.string :country
      t.string :province
      t.string :city
      t.string :address
      t.string :postal_code

      t.string :shipping_company
      t.string :tracking_number

      t.datetime :paid_at
      t.datetime :shipped_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :discourse_shop_orders, :user_id
    add_index :discourse_shop_orders, :status
  end
end
