
import { apiInitializer } from "discourse/lib/api";
import { ajax } from "discourse/lib/ajax";

export default apiInitializer("0.11.1", (api) => {
  // Add routes
  api.modifyClass("Route:application", {
    actions: {
      goShop() { this.transitionTo("shop.index"); },
      goShopAdmin() { this.transitionTo("shop-admin.index"); },
    },
  });

  api.addNavigationBarItem({
    name: "shop",
    displayName: "商城",
    title: "商城",
    href: "/shop",
    forceActive: (category, args, router) => router.currentRouteName?.startsWith("shop")
  });

  // Make sure mobile shows it as well (we'll also add connector)
});
