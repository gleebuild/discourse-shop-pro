
export default function () {
  this.route("shop", { path: "/shop" }, function () {
    this.route("product", { path: "/product/:id" });
    this.route("checkout", { path: "/checkout" });
    this.route("complete", { path: "/complete" });
  });
  this.route("shop-admin", { path: "/shop/admin" });
}
