
class UserOrder {
  final String orderDate;
  final String status;
  final String totalAmount;
  final String userId;
  final List<OrderItem> orderItems;

  UserOrder({
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.userId,
    required this.orderItems,
  });

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    final orderItemsData = map['orderItems'] as List<dynamic>? ?? [];
    final orderItems = orderItemsData
        .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return UserOrder(
      orderDate: map['orderDate'] ?? '',
      status: map['status'] ?? '',
      totalAmount: map['totalAmount'] ?? '0.0' ?? 0.0,
      userId: map['userId'] ?? '',
      orderItems: orderItems,
    );
  }
}

class OrderItem {
  final String name;
  final String productId;
  final String boxId;
  final int quantity;

  OrderItem({
    required this.name,
    required this.productId,
    required this.boxId,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      productId: map['productId'] ?? '',
      boxId: map['boxId'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}
