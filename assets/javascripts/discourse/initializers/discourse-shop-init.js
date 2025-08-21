
import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.0.0", (api) => {
  api.addNavigationBarItem({
    name: "shop",
    displayName: "商城",
    title: "商城",
    href: "/shop",
    displayCondition: () => true,
    forceActive: (_category, _args, router) => router.currentRouteName?.startsWith("shop"),
  });

  api.addNavigationBarItem({
    name: "shop-admin",
    displayName: "管理",
    title: "管理",
    href: "/shop/admin",
    displayCondition: () => !!api.getCurrentUser?.()?.staff,
    forceActive: (_category, _args, router) => router.currentRouteName?.startsWith("shop-admin"),
  });
});
