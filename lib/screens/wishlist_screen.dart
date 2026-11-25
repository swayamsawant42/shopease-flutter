import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../state/shop_state.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final items = products.where(shop.isWishlisted).toList();

    return Scaffold(
      appBar: AppBar(title: Text('My Wishlist (${items.length})')),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 96, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('Your wishlist is empty', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  const Text('Tap the heart on any product to save it here.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
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
