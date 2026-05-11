import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/grocery_provider.dart';

class ListDetailScreen extends StatefulWidget {
  const ListDetailScreen({super.key});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _shareController = TextEditingController();
  String _selectedCategory = 'General';

  void _showAddItemDialog(String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _itemController,
                decoration: const InputDecoration(labelText: "Item Name")),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory, // Ginagamit ang value para sa initial selection
              items: ['General', 'Produce', 'Meat', 'Dairy']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_itemController.text.isNotEmpty) {
                Provider.of<GroceryProvider>(context, listen: false)
                    .addItemToList(listId, _itemController.text.trim(),
                        _selectedCategory);
                _itemController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(body: Center(child: Text("Error: No data received")));
    }

    final String listId = args['id'];
    final String listTitle = args['title'];

    return Scaffold(
      appBar: AppBar(
        title: Text(listTitle),
        backgroundColor: const Color(0xFF00ACC1),
        actions: [
          IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Share List"),
                    content: TextField(
                        controller: _shareController,
                        decoration: const InputDecoration(hintText: "Email")),
                    actions: [
                      ElevatedButton(
                          onPressed: () async {
                            String res = await Provider.of<GroceryProvider>(
                                    context,
                                    listen: false)
                                .shareWithFriend(
                                    listId, _shareController.text.trim());
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(res)));
                            }
                          },
                          child: const Text("Share"))
                    ],
                  ),
                );
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shopping_lists')
            .doc(listId)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading items"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return const Center(child: Text("No items yet."));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final bool isDone = item['isDone'] ?? false;

              // 1. DISMISSIBLE - Swipe to Delete Animation
              return Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  item.reference.delete();
                },
                child: ListTile(
                  leading: Checkbox(
                    activeColor: const Color(0xFF00ACC1),
                    value: isDone,
                    onChanged: (v) => item.reference.update({'isDone': v}),
                  ),
                  // 2. ANIMATED DEFAULT TEXT STYLE - Strikethrough Animation
                  title: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 16,
                      color: isDone ? Colors.grey : Colors.black,
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: isDone ? FontWeight.normal : FontWeight.w500,
                    ),
                    child: Text(item['name']),
                  ),
                  subtitle: Text(
                    item['category'],
                    style: TextStyle(
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFA000),
        onPressed: () => _showAddItemDialog(listId),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}