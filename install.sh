#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "[shop_pro] Ensuring plugin.rb loads engine files (idempotent)..."
if ! grep -q 'discourse_shop_pro.rb' plugin.rb; then
  echo 'load File.expand_path("lib/discourse_shop_pro.rb", __dir__)' >> plugin.rb
fi
if ! grep -q 'discourse_shop_pro/engine.rb' plugin.rb; then
  echo 'load File.expand_path("lib/discourse_shop_pro/engine.rb", __dir__)' >> plugin.rb
fi

echo "[shop_pro] Done. Next steps inside Discourse container:"
cat <<'EOS'

1) Rebuild or restart app, e.g.:
   sv restart unicorn

2) (Optional) Run migrations + seed:
   RAILS_ENV=production bundle exec rake db:migrate
   RAILS_ENV=production bundle exec rake shop_pro:seed

3) Verify endpoints:
   curl -sS http://localhost:3000/shop/_health
   curl -sS http://localhost:3000/shop/public/products.json

EOS
