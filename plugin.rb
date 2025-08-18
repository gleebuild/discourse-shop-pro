# name: discourse-shop-pro
# about: Public shop pages and JSON (no DB required; demo data fallback)
# version: 0.1.0
# authors: ShopPro Team
# url: https://example.com/discourse-shop-pro

load File.expand_path("lib/discourse_shop_pro.rb", __dir__)
load File.expand_path("lib/discourse_shop_pro/engine.rb", __dir__)

after_initialize do
  # no-op; routes are in engine
end
