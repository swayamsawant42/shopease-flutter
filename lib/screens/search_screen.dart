import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? const []
        : products
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                p.brand.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search for products, brands and more',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: q.isEmpty
          ? const Center(child: Text('Try "phone", "shoes" or "laptop"'))
          : results.isEmpty
              ? Center(child: Text('No results for "$_query"'))
              : ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final p = results[i];
                    return ListTile(
                      tileColor: Colors.white,
                      leading: SizedBox(width: 48, height: 48, child: ProductImage(product: p, size: 28)),
                      title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: PriceRow(p, fontSize: 13),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      ),
                    );
                  },
                ),
    );
  }
}
