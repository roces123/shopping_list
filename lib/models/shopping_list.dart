import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  final String id;
  final String title;
  final String ownerId;
  final List<String> members; // Para sa sharing feature
  final DateTime? createdAt;

  ShoppingList({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.members,
    this.createdAt,
  });

  factory ShoppingList.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ShoppingList(
      id: doc.id,
      title: data['title'] ?? 'Untitled List',
      ownerId: data['ownerId'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ownerId': ownerId,
      'members': members,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}