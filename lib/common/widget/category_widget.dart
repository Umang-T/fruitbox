import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/features/user/models/category_model.dart';

class CategoryWidget extends StatefulWidget {
  final ScrollController scrollController;

  const CategoryWidget({super.key, required this.scrollController});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late List<Category> categoryList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        print(snapshot.data?.docs);

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }

        categoryList = snapshot.data!.docs.map((doc) {
          return Category.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();

        return SingleChildScrollView(
          controller: widget.scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: categoryList.map((categories) {
                return FutureBuilder<bool>(
                  future: hasProductsForCategory(categories.name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    final bool hasProducts = snapshot.data ?? false;

                    return hasProducts
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                print('Category tapped: ${categories.name}');
                                scrollToCategory(categories.name);
                              },
                              child: CategoriesCard(categories: categories),
                            ),
                          )
                        : const SizedBox();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<bool> hasProductsForCategory(String categoryName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category_name', isEqualTo: categoryName)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking products: $error');
      return false;
    }
  }

  void scrollToCategory(String categoryName) {
    final categoryIndex =
        categoryList.indexWhere((category) => category.name == categoryName);
    if (categoryIndex != -1) {
      const cardWidth = 300.0;
      final scrollPosition = categoryIndex * cardWidth;
      widget.scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}

class CategoriesCard extends StatelessWidget {
  final Category categories;

  const CategoriesCard({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          width: 50,
          height: 50,
          child: Image.network(
            categories.imgUrl,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return const Icon(Icons.error);
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          categories.name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
