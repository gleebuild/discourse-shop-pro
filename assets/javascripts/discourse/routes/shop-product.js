
import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";

export default class ShopProductRoute extends DiscourseRoute {
  model(params) {
    return ajax(`/shop/public/products/${params.id}.json`);
  }
}
