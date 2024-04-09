class CartItem {
  final String productName;
  final String productId;
  final String price;
  int quantity;

  CartItem({
    required this.productName,
    required this.productId,
    required this.price,
    required this.quantity
  });
}
