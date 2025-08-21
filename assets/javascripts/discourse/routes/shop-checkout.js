
import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class ShopCheckoutRoute extends DiscourseRoute {
  queryParams = { product_id: { refreshModel: true }, variant_id: { refreshModel: true }, qty: { refreshModel: true } };

  model(params) {
    return ajax(`/shop/public/products/${params.product_id}.json`).then((res) => {
      return { product: res.product, params };
    });
  }

  setupController(controller, model) {
    super.setupController(controller, model);
  }
}
