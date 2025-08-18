# frozen_string_literal: true
class CreateShopProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_products do |t|
      t.string  :title, null: false
      t.text    :description
      t.jsonb   :images, default: []
      t.jsonb   :specs, default: []
      t.integer :price_cents, null: false, default: 0
      t.boolean :on_sale, null: false, default: true
      t.timestamps
    end
    add_index :shop_products, :on_sale
  end
end
