class AppConfig {
  static const host = "https://westmarket.herokuapp.com/api/v1";

  static const user = "$host/user/";
  static const signup = "$host/user/register";
  static const login = "$host/user/login";
  static const verify = "$host/user/verify-email";
  static const fund = "$host/user/wallet/"; //:userId/recharge
  static const productsListing = "$host/user/products"; //:userId/products;
  static const addToCart = "$host/user/cart/add-item";
  static const checkout = "$host/user/cart/checkout";
  static const getCart = "$host/user/"; //:userId/cart?orderId=ijKy7PsiSM
}
