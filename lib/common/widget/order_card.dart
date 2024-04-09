import 'package:flutter/material.dart';
import '../../features/user/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final UserOrder order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text('Order Date: ${order.orderDate}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${order.status}'),
            Text('Total: Rs.${order.totalAmount}'),
            const Text('Items:'),
            for (final item in order.orderItems)
              Text(
                '${item.quantity} x ${item.name}',
              ),
          ],
        ),
        trailing: order.status == 'Pending'
            ? ElevatedButton(
                onPressed: () {
                  showComingSoonSnackbar(context);
                  print('Track Order Button Pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFFC201), // Background color
                ),
                child: const Text('Track Order'),
              )
            : null,
      ),
    );
  }

  void showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Track Order feature is coming soon!'),
      ),
    );
  }
}
