import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String id;
  final String name;
  final String category;
  bool isBought;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    this.isBought = false,
  });

  // Mahalaga ito para sa Firebase integration (Bonus +10 pts)
  factory ShoppingItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ShoppingItem(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'General',
      isBought: data['isBought'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'isBought': isBought,
    };
  }
}