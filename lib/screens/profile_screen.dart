import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF00ACC1),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Kukunin natin ang Full Name sa Firestore gamit ang UID
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final fullName = userData?['fullName'] ?? "No Name";

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFFFA000),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                
                // Display Name & Email
                ListTile(
                  leading: const Icon(Icons.badge, color: Color(0xFF00ACC1)),
                  title: const Text("Full Name"),
                  subtitle: Text(fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Color(0xFF00ACC1)),
                  title: const Text("Email"),
                  subtitle: Text(user?.email ?? "No Email"),
                ),
                
                const Spacer(),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false).logout();
                      if (context.mounted) Navigator.pushReplacementNamed(context, '/');
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("LOGOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("v1.0.0", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}