// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/global_variables.dart';
import '../../../razor_pay.dart';
import '../../user/models/cart_model.dart';
import '../../user/models/order_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<CartItem> cartItems;
  late Stream<QuerySnapshot> cartItemStream;
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();
    cartItems = [];
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonHeader(),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : buildCartBody(),
    );
  }

  Widget buildProfileButton() {
    return _auth.currentUser == null
        ? TextButton.icon(
            onPressed: () {
              navigateToLogin();
            },
            icon: const Icon(Icons.login, color: Colors.black),
            label: const Text('Login', style: TextStyle(color: Colors.black)),
          )
        : IconButton(
            onPressed: () {
              navigateToProfile();
            },
            padding: const EdgeInsets.only(right: appPading),
            icon: const Icon(CupertinoIcons.person_alt_circle_fill,
                color: Colors.black, size: 35),
          );
  }

  Widget buildCartBody() {
    return Column(
      children: [
        buildCartList(),
        const Divider(),
        buildTotalSection(),
        ElevatedButton(
          onPressed: () {
            showPaymentConfirmationDialog(); // Show payment confirmation dialog
          },
          child: const Text('Proceed to Payment'),
        ),
      ],
    );
  }

  Widget buildCartList() {
    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return CartItemWidget(
            item: item,
            onUpdate: (newQuantity) {
              updateQuantity(item, newQuantity);
            },
            onRemove: () {
              showRemoveItemDialog(item);
            },
          );
        },
      ),
    );
  }

  Widget buildTotalSection() {
    double totalCost = calculateTotalCost();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total: Rs. $totalCost',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void updateQuantity(CartItem item, int newQuantity) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userCartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart');
        final cartItemRef = userCartRef.doc(item.productId);

        print('Updating quantity for item: ${item.productId}');
        final docSnapshot = await cartItemRef.get();
        if (docSnapshot.exists) {
          if (newQuantity > 0) {
            await cartItemRef.update({'quantity': newQuantity});
            setState(() {
              item.quantity = newQuantity;
            });
          } else {
            await cartItemRef.delete();
            setState(() {
              cartItems.remove(item);
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quantity updated successfully'),
            ),
          );
        } else {
          print('Document does not exist for item: ${item.productId}');
        }
      }
    } catch (e) {
      print('Error updating quantity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update quantity'),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.pushNamed(context, 'register');
    print('Navigate to login');
  }

  void navigateToProfile() {
    Navigator.pushNamed(context, 'profile');
    print('Navigate to profile');
  }

  void showPaymentConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Proceed to Payment'),
          content: const Text('Are you sure you want to proceed to payment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                proceedToPayment();
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  void proceedToPayment() async {
    try {
      double totalCost = calculateTotalCost();
      RazorpayPaymentPageState razorpayState = RazorpayPaymentPageState();
      razorpayState.openCheckout(totalCost);
    } catch (e) {
      print('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to proceed with payment'),
        ),
      );
    }
  }

  void showRemoveItemDialog(CartItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text(
              'Are you sure you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                removeItemFromCart(item);
                Navigator.pop(context);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  double calculateTotalCost() {
    double total = 0.0;
    for (var cartItem in cartItems) {
      total += double.parse(cartItem.price) * cartItem.quantity;
    }
    return total;
  }

  Future<void> fetchCartItems() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userCartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart');
        final snapshot = await userCartRef.get(); // Fetch the cart items once

        setState(() {
          cartItems = snapshot.docs.map((doc) {
            final data = doc.data();
            return CartItem(
              productName: data['productName'],
              price: data['price'],
              quantity: data['quantity'],
              productId: data['productId'],
            );
          }).toList();
        });

        print('Cart items fetched successfully.');
        print('Number of items in cart: ${cartItems.length}');

        // Listen to future changes
        userCartRef.snapshots().listen((QuerySnapshot snapshot) {
          print('Snapshot data: ${snapshot.docs}');
          if (mounted) {
            setState(() {
              cartItems = snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return CartItem(
                  productName: data['productName'],
                  price: data['price'],
                  quantity: data['quantity'],
                  productId: data['productId'],
                );
              }).toList();
            });
            print('Cart items updated successfully.');
            print('Number of items in cart: ${cartItems.length}');
          }
        });
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  void removeItemFromCart(CartItem item) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userCartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart');
        await userCartRef
            .where('productId', isEqualTo: item.productId)
            .get()
            .then((snapshot) {
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });
        print('Item removed from cart: ${item.productName}');
      }
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  void proceedToCheckout() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final userCartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart');

        // Fetch the current items in the cart
        final currentItems = await userCartRef.get();

        if (currentItems.docs.isNotEmpty) {
          // Step 1: Create a new order
          final orderDate = DateTime.now().toIso8601String();
          final totalAmount = calculateTotalCost().toString();

          final newOrder = UserOrder(
            orderDate: orderDate,
            status: 'Pending',
            totalAmount: totalAmount,
            userId: userId,
            orderItems: cartItems.map((cartItem) {
              return OrderItem(
                name: cartItem.productName,
                productId: cartItem.productId,
                boxId: '', // You can set this value based on your requirements
                quantity: cartItem.quantity,
              );
            }).toList(),
          );

          // Step 2: Add the new order to the "orders" collection
          await FirebaseFirestore.instance.collection('orders').add({
            'orderDate': newOrder.orderDate,
            'status': newOrder.status,
            'totalAmount': newOrder.totalAmount,
            'userId': newOrder.userId,
            'orderItems': newOrder.orderItems.map((orderItem) {
              return {
                'name': orderItem.name,
                'productId': orderItem.productId,
                'boxId': orderItem.boxId,
                'quantity': orderItem.quantity,
              };
            }).toList(),
          });

          clearCart();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your cart is empty. Add items before proceeding.'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error processing checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to proceed to checkout'),
        ),
      );
    }
  }

  void clearCart() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userCartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart');
        final currentItems = await userCartRef.get();
        if (mounted) {
          await userCartRef.get().then((snapshot) {
            for (QueryDocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          });
          if (mounted) {
            setState(() {
              cartItems.clear();
            });
          }
        }

        print('Cart cleared successfully.');
        print('Number of items in cart: ${currentItems.docs.length}');
      }
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  PreferredSizeWidget? buildCommonHeader() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text(
        'Shopping Cart',
        style: TextStyle(color: Colors.black),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black, // Set the back button color to black
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      actions: [
        buildProfileButton(),
      ],
    );
  }

}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onUpdate;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onUpdate,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.productName),
      subtitle: Text('Quantity: ${item.quantity}Kg'),
      trailing: Text('Rs. ${double.parse(item.price) * item.quantity}'),
      onTap: () {
        print('Item tapped: ${item.productName}'); // Debug print
      },
      onLongPress: () {
        print('Item long pressed: ${item.productName}'); // Debug print
        onRemove();
      },
      contentPadding: const EdgeInsets.all(16),
      dense: false, // Allow more spacing between items
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 16,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              print('Minus button pressed'); // Debug print
              onUpdate(item.quantity - 1);
            },
          ),
          SizedBox(
            width: 40,
            child: Center(
                child: Text(
              item.quantity.toString(),
              style: const TextStyle(
                fontSize: 28, // Adjust the font size as needed
              ),
            )),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              print('Plus button pressed'); // Debug print
              onUpdate(item.quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
