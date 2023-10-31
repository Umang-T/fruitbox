import 'package:cloud_firestore/cloud_firestore.dart';

class category {
  final String name;
  final String description;
  final String imgUrl;
  final String category_id;

  category({
    required this.name,
    required this.description,
    required this.imgUrl,
    required this.category_id,
  });

  factory category.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return category(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      category_id: data['pricePerKg'] ?? '',
    );
  }
}