import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruitbox/features/user/models/category_model.dart';
import '../../features/user/models/product_model.dart';

class PopularItemsWidget extends StatelessWidget {
  final Category category;

  const PopularItemsWidget({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('category_name', isEqualTo: category.name)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }

        final products = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product(
            productId: doc.id,
            categoryName: data['category_name'],
            description: data['description'],
            imageUrl: data['imageUrl'],
            name: data['name'],
            price: data['price'],
          );
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: products.map((product) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ProductCard(product: product),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 215,
      child: Container(
        height: quantity > 0 ? 325 : 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 130,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return const Icon(Icons.error);
                  },
                ),
              ),
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs. ${widget.product.price}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xffFFC201),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (quantity == 0)
                    InkResponse(
                      onTap: () {
                        setState(() {
                          quantity = 1;
                        });
                      },
                      child: const Icon(
                        Icons.add_box,
                        color: Color(0xffFFC201),
                        size: 26,
                      ),
                    ),
                ],
              ),
              if (quantity > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity: $quantity',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity = quantity > 1 ? quantity - 1 : 0;
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity = quantity + 1;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add the item to the cart and update the database
                        addToCart();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void addToCart() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userDocSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDocSnapshot.exists) {
          final userCartRef = userDocSnapshot.reference.collection('cart');
          final cartItemDoc = userCartRef.doc(widget.product.productId);

          final cartItemDocSnapshot = await cartItemDoc.get();

          if (cartItemDocSnapshot.exists) {
            // Product already exists in the cart, update the quantity
            final currentQuantity = cartItemDocSnapshot['quantity'] ?? 0;
            await cartItemDoc.update({'quantity': currentQuantity + quantity});
          } else {
            // Product doesn't exist in the cart, add a new item
            await cartItemDoc.set({
              'productId': widget.product.productId,
              'productName': widget.product.name,
              'price': widget.product.price,
              'quantity': quantity,
            });
          }

          setState(() {
            quantity = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item added to cart'),
            ),
          );
        } else {
          // User document doesn't exist
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }
}
