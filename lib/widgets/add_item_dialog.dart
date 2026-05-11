import 'package:flutter/material.dart';

class AddItemDialog extends StatelessWidget {
  final Function(String name, String category) onAdd;

  const AddItemDialog({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Item Name')),
          TextField(controller: categoryController, decoration: const InputDecoration(hintText: 'Category')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              onAdd(nameController.text, categoryController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}