import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroceryItem {
  final String id;
  final String name;
  final String category;
  final bool isDone;

  GroceryItem({required this.id, required this.name, required this.category, this.isDone = false});
}

class GroceryProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GET ALL LISTS WHERE USER IS A MEMBER
  Stream<QuerySnapshot> get myLists {
    String uid = _auth.currentUser?.uid ?? "";
    return _db
        .collection('shopping_lists')
        .where('members', arrayContains: uid)
        .snapshots();
  }

  // CREATE NEW LIST
  Future<void> createNewList(String title) async {
    String uid = _auth.currentUser?.uid ?? "";
    if (uid.isEmpty) return;
    await _db.collection('shopping_lists').add({
      'title': title,
      'ownerId': uid,
      'members': [uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ADD ITEM TO A SPECIFIC LIST
  Future<void> addItemToList(String listId, String itemName, String category) async {
    await _db.collection('shopping_lists').doc(listId).collection('items').add({
      'name': itemName,
      'category': category,
      'isDone': false, // Default na hindi pa tapos
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // TOGGLE ITEM STATUS (Para sa strikethrough effect)
  Future<void> toggleItemStatus(String listId, String itemId, bool status) async {
    await _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({'isDone': status});
  }

  // DELETE THE ENTIRE LIST (Para sa HomeScreen delete button)
  Future<void> deleteList(String listId) async {
    try {
      await _db.collection('shopping_lists').doc(listId).delete();
      notifyListeners();
    } catch (e) {
      //debugPrint("Error deleting list: $e");
    }
  }

  // SHARE LIST
  Future<String> shareWithFriend(String listId, String friendEmail) async {
    try {
      var friendDoc = await _db.collection('users').where('email', isEqualTo: friendEmail).get();
      if (friendDoc.docs.isEmpty) return "User not found!";
      
      String friendUid = friendDoc.docs.first.id;
      await _db.collection('shopping_lists').doc(listId).update({
        'members': FieldValue.arrayUnion([friendUid])
      });
      return "Success!";
    } catch (e) {
      return "Error: $e";
    }
  }
}