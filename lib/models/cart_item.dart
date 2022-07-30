class CartItem {
  String productId;
  int quantity;
  double amount;
  String unitId;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.unitId,
    required this.amount,
  });
}
