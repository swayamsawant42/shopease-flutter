import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';

enum SortBy { relevance, priceLow, priceHigh, rating, discount }

class ProductListScreen extends StatefulWidget {
  final String title;
  final List<Product> items;
  const ProductListScreen({super.key, required this.title, required this.items});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  SortBy _sort = SortBy.relevance;

  List<Product> get _sorted {
    final list = [...widget.items];
    switch (_sort) {
      case SortBy.relevance:
        break;
      case SortBy.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortBy.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortBy.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortBy.discount:
        list.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final items = _sorted;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (s) => setState(() => _sort = s),
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortBy.relevance, child: Text('Relevance')),
              PopupMenuItem(value: SortBy.priceLow, child: Text('Price: Low to High')),
              PopupMenuItem(value: SortBy.priceHigh, child: Text('Price: High to Low')),
              PopupMenuItem(value: SortBy.rating, child: Text('Customer Rating')),
              PopupMenuItem(value: SortBy.discount, child: Text('Discount')),
            ],
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('No products found'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.62,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => ProductCard(product: items[i]),
            ),
    );
  }
}
