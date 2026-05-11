import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/grocery_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _listTitleController = TextEditingController();

  // Function para sa Confirmation bago mag-delete ng listahan
  void _confirmDelete(BuildContext context, String listId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete List?"),
        content: Text("Are you sure you want to delete '$title'? This will remove the entire list for everyone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<GroceryProvider>(context, listen: false).deleteList(listId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("'$title' deleted")),
              );
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Shopping List"),
        content: TextField(
          controller: _listTitleController, 
          decoration: const InputDecoration(hintText: "List Title")
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_listTitleController.text.isNotEmpty) {
                Provider.of<GroceryProvider>(context, listen: false)
                    .createNewList(_listTitleController.text.trim());
                _listTitleController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groceryProvider = Provider.of<GroceryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("CoShopLists"),
        backgroundColor: const Color(0xFF00ACC1),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: groceryProvider.myLists,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final docs = snapshot.data!.docs;
          
          if (docs.isEmpty) {
            return const Center(child: Text("No lists yet. Create one!"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final String listId = docs[index].id;
              final String listTitle = data['title'] ?? 'Untitled';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.list_alt, color: Color(0xFFFFA000)),
                  title: Text(
                    listTitle, 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                  // PINALITAN: Dito na ang Delete Button sa main list
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context, listId, listTitle),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      '/details', 
                      arguments: {'id': listId, 'title': listTitle}
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFA000),
        onPressed: _showCreateListDialog, 
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}