import 'package:flutter/material.dart';
import '../models/shopping_item.dart';

class GroceryItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const GroceryItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: item.isBought,
        activeColor: const Color(0xFF00ACC1),
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.isBought ? TextDecoration.lineThrough : null,
          color: item.isBought ? Colors.grey : Colors.black,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        onPressed: onDelete,
      ),
    );
  }
}