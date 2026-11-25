import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import 'product_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final c = categories[i];
          final count = products.where((p) => p.category == c.name).length;
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: c.name,
                    items: products.where((p) => p.category == c.name).toList(),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: c.color.withValues(alpha: 0.15),
                    child: Icon(c.icon, color: c.color, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('$count items', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
