# frozen_string_literal: true
class CreateShopTables < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_products do |t|
      t.string  :title, null: false
      t.string  :slug, index: true
      t.text    :description
      t.integer :price_cents, null: false, default: 0
      t.string  :currency, null: false, default: "CNY"
      t.string  :image_url
      t.jsonb   :specs, null: false, default: []
      t.integer :stock, null: false, default: 0
      t.boolean :published, null: false, default: true
      t.timestamps
    end

    create_table :shop_coupons do |t|
      t.string  :code, null: false
      t.integer :amount_off_cents, null: false, default: 0
      t.datetime :expires_at
      t.integer :usage_limit
      t.integer :times_used, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :shop_product, foreign_key: { to_table: :shop_products }
      t.timestamps
    end
    add_index :shop_coupons, :code, unique: true

    create_table :shop_orders do |t|
      t.references :shop_product, foreign_key: { to_table: :shop_products }, null: false
      t.string  :sku
      t.integer :quantity, null: false, default: 1
      t.integer :unit_price_cents, null: false, default: 0
      t.integer :discount_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.string  :currency, null: false, default: "CNY"
      t.string  :status, null: false, default: "pending"
      t.string  :pay_mode, null: false, default: "native"
      t.string  :out_trade_no, null: false
      t.string  :wechat_prepay_id
      t.string  :wechat_transaction_id
      t.string  :h5_url
      t.string  :client_ip
      t.string  :payer_openid
      t.string  :coupon_code
      t.timestamps
    end
    add_index :shop_orders, :out_trade_no, unique: true
  end
end