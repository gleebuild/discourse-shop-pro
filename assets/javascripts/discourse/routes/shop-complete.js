
import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";

export default class ShopCompleteRoute extends DiscourseRoute {
  queryParams = { order_id: { refreshModel: true } };
  model(params) {
    return ajax(`/shop/public/orders/${params.order_id}.json`);
  }
}
