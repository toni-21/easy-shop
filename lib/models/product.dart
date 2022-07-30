class Product {
  String name;
  String id;
  double price;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
  });
}
