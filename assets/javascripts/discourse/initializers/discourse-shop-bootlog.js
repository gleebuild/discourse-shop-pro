
import { apiInitializer } from "discourse/lib/api";
export default apiInitializer("1.0.0", () => {
  // eslint-disable-next-line no-console
  console.log("[shop] front-end initialized: routes /shop, /shop/admin; api base /shop-api");
});
