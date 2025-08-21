
import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";

export default class ShopIndexRoute extends DiscourseRoute {
  model() {
    return ajax("/shop/public/products.json");
  }
}
