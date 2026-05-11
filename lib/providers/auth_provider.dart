import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Chine-check kung may user na naka-login
  bool get isAuthenticated => _auth.currentUser != null;

  // REGISTRATION - Updated with fullName
  Future<String?> register(String email, String password, String fullName) async {
    try {
      // 1. Gagawa ng account sa Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // 2. I-save ang user details sa Firestore 'users' collection
      // Kasama na ang 'fullName' field dito
      await _db.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': email.toLowerCase().trim(),
        'fullName': fullName.trim(), // <--- Eto ang dagdag natin
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      return "success"; 
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An error occurred during registration.";
    }
  }

  // LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}