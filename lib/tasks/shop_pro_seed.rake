# frozen_string_literal: true
namespace :shop_pro do
  desc "Seed demo products for discourse-shop-pro"
  task seed: :environment do
    begin
      unless defined?(::DiscourseShopPro::Product)
        puts "[shop_pro] Product model missing"
        next
      end
      if ::DiscourseShopPro::Product.count == 0
        ::DiscourseShopPro::Product.create!(title: "Demo Hoodie", price_cents: 5999, images: [], specs: [])
        ::DiscourseShopPro::Product.create!(title: "Demo Mug", price_cents: 1999, images: [], specs: [])
        puts "[shop_pro] Seeded 2 products"
      else
        puts "[shop_pro] Products already present"
      end
    rescue => e
      puts "[shop_pro] Seed failed: #{e.class}: #{e.message}"
    end
  end
end
