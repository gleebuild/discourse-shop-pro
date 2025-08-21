
import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("0.11.1", (api) => {
  const currentUser = api.getCurrentUser?.();

  api.addNavigationBarItem({
    name: "shop",
    displayName: "商城",
    title: "商城",
    href: "/shop",
    forceActive: (_category, _args, router) => router.currentRouteName?.startsWith("shop")
  });

  if (currentUser?.staff) {
    api.addNavigationBarItem({
      name: "shop-admin",
      displayName: "管理",
      title: "管理",
      href: "/shop/admin",
      forceActive: (_category, _args, router) => router.currentRouteName?.startsWith("shop-admin")
    });
  }
});
