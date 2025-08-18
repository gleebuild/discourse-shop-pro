# name: discourse-shop-pro
# about: Simple shop for Discourse with public product pages and basic order admin
# version: 0.2.0
# authors: ChatGPT
# url: https://lebanx.com/
enabled_site_setting :shop_pro_enabled

load File.expand_path("lib/discourse_shop_pro.rb", __dir__)
load File.expand_path("lib/discourse_shop_pro/engine.rb", __dir__)

after_initialize do
  # plugin initialized
end
