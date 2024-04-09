// order_details_screen.dart

import 'package:flutter/material.dart';
import '../../user/models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final UserOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for OrderDetailsScreen using the order information
    // ...

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      // Rest of the code for OrderDetailsScreen...
    );
  }
}
