# discourse-shop-pro (complete demo)

A minimal-yet-functional shop plugin for Discourse:
- Public product list & detail pages
- JSON APIs
- Optional DB-backed Product model with migrations
- Health endpoint for quick verification
- Admin stub for orders (JSON)

## Install
1. Copy folder into `/var/www/discourse/plugins/discourse-shop-pro`.
2. Inside the container:
   ```bash
   cd /var/www/discourse/plugins/discourse-shop-pro
   bash install.sh
   sv restart unicorn
   RAILS_ENV=production bundle exec rake db:migrate
   RAILS_ENV=production bundle exec rake shop_pro:seed
   ```

## Endpoints
- `/shop/_health`
- `/shop/public/products` (+ `.json`)
- `/shop/public/products/:id` (+ `.json`)

If the DB/table doesn't exist yet, the endpoints still return demo data.
