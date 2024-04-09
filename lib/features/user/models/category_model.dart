import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String description;
  final String imgUrl;
  final String categoryId;

  Category({
    required this.name,
    required this.description,
    required this.imgUrl,
    required this.categoryId,
  });

  factory Category.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Category(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      categoryId: data['pricePerKg'] ?? '',
    );
  }
}