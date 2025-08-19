# discourse-shop-pro

Minimal Discourse shop plugin with WeChat Pay v3 (Native/H5) and coupons.

## Install

1. Copy the folder to your server: `/var/discourse/plugins/discourse-shop-pro`
2. Rebuild Discourse:

```bash
cd /var/discourse
./launcher rebuild app
```

3. In Admin → Settings → Plugins, search `shop_` and fill in WeChat config.
4. Visit **Admin → Plugins → Shop** to create products & coupons.
5. Public catalog at `/shop/products`, product page `/shop/products/:id`.

## Notes

- Native (PC) shows a QR code. H5 returns an `h5_url` for mobile browsers.
- WeChat notify path: `/shop/wechatpay/notify` (configure this in WeChat Pay portal).
- This is a minimal reference implementation. Please audit before production.