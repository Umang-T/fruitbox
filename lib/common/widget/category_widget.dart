import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/features/user/models/category_model.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

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

        final categoryList = snapshot.data!.docs.map((doc) {
          return category
              .fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: categoryList.map((categories) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CategoriesCard(categories: categories),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class CategoriesCard extends StatelessWidget {
  final category categories;
  const CategoriesCard({Key? key, required this.categories}) : super(key: key);
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
