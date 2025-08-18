# discourse-shop-pro (lite)

Public-facing shop pages & JSON for Discourse, **no database required**.

## Routes
- `/shop/_health` → `{"ok":true}`
- `/shop/public/products` (HTML)
- `/shop/public/products.json` (JSON)
- `/shop/public/products/:id` (HTML)
- `/shop/public/products/:id.json` (JSON)

## Install (inside container)
```bash
cd /var/www/discourse/plugins
# unzip the package to plugins/
# restart app server
sv restart unicorn
```

## Notes
- Uses demo data to avoid boot failures during migrations.
- Safe to keep during bootstrap; it does not touch DB.
- You can later replace the data provider with a real model/query.
