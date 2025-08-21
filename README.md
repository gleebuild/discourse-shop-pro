
# Discourse Shop Pro (2025-08-21)

A minimal-yet-complete Discourse plugin that adds a Mall (商城) and Admin (管理) experience with:

- Products, Variants, Coupons, Orders (DB-backed)
- Pluggable payments (WeChat / PayPal via separate plugins). Built-in `sandbox` provider auto-pays for demo.
- Right-side navigation: **商城** and **管理** on the homepage next to Latest/Top/Categories
- Mobile 2-per-row, Desktop 4-per-row product grid
- Checkout with shipping fields and coupon code

## Install

Add to `app.yml`:

```
hooks:
  after_code:
    - git clone https://example.invalid/discourse-shop-pro.git
```

Then:
```
./launcher rebuild app
```

## Payment Integration

Other plugins can register providers:

```ruby
DiscourseShop::PaymentGateway.register('wechat', MyWechatProvider)
```

The provider must implement:

```ruby
def self.create_payment(order:, return_url:, notify_url: nil, ip: nil, ua: nil)
  DiscourseShop::PaymentResult.new(provider: 'wechat', pay_url: 'https://...', payload: {...})
end
```

## Logging

Key actions append logs to `/var/www/discourse/public/wechat.txt` using the provided logger.
