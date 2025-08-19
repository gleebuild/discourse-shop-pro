import { withPluginApi } from "discourse/lib/plugin-api";
export default {
  name: "discourse-shop-pro-admin-route",
  initialize() {
    withPluginApi("1.6.0", (api) => {
      api.addAdminMenuItem({
        icon: "shopping-cart",
        route: "adminPlugins.shop",
        label: "shop.title",
      });
    });
  },
};