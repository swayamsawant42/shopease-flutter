import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/shop_state.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final inCart = shop.inCart(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.brand),
        actions: [
          IconButton(
            icon: Icon(shop.isWishlisted(product) ? Icons.favorite : Icons.favorite_border),
            onPressed: () => shop.toggleWishlist(product),
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: shop.cartCount > 0,
              label: Text('${shop.cartCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: AspectRatio(aspectRatio: 1.3, child: ProductImage(product: product, size: 140)),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.brand, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(product.name, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Row(children: [
                  RatingBadge(product.rating),
                  const SizedBox(width: 8),
                  Text('${product.reviews} ratings', style: const TextStyle(color: Colors.grey)),
                ]),
                const SizedBox(height: 12),
                PriceRow(product, fontSize: 22),
                const SizedBox(height: 6),
                Text(
                  product.price >= 500 ? 'Free delivery' : 'Delivery ₹40',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (product.highlights.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Highlights',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  for (final h in product.highlights)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        const Icon(Icons.circle, size: 6, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text(h)),
                      ]),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            child: const Column(children: [
              ListTile(leading: Icon(Icons.replay), title: Text('7 days replacement policy')),
              ListTile(leading: Icon(Icons.money), title: Text('Cash on Delivery available')),
              ListTile(leading: Icon(Icons.verified_user), title: Text('1 year warranty')),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () {
                    if (inCart) {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const CartScreen()));
                    } else {
                      shop.addToCart(product);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(content: Text('Added to cart')));
                    }
                  },
                  child: Text(inCart ? 'GO TO CART' : 'ADD TO CART',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 54,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFB641B),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () {
                    if (!inCart) shop.addToCart(product);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                  },
                  child: const Text('BUY NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
