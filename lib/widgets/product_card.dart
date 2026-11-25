import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../state/shop_state.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final double size;

  const ProductImage({super.key, required this.product, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [product.color.withValues(alpha: 0.15), product.color.withValues(alpha: 0.35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(product.icon, size: size, color: product.color),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  const RatingBadge(this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: rating >= 4 ? Colors.green.shade700 : Colors.orange.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rating.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 2),
          const Icon(Icons.star, color: Colors.white, size: 12),
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final Product product;
  final double fontSize;
  const PriceRow(this.product, {super.key, this.fontSize = 15});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(rupees(product.price),
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
        Text(rupees(product.mrp),
            style: TextStyle(
                fontSize: fontSize - 3,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough)),
        Text('${product.discountPercent}% off',
            style: TextStyle(
                fontSize: fontSize - 3,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Card(
      elevation: 0.5,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: ProductImage(product: product)),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          shop.isWishlisted(product) ? Icons.favorite : Icons.favorite_border,
                          color: shop.isWishlisted(product) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => shop.toggleWishlist(product),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Row(children: [
                RatingBadge(product.rating),
                const SizedBox(width: 6),
                Flexible(
                  child: Text('(${product.reviews})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ),
              ]),
              const SizedBox(height: 4),
              PriceRow(product, fontSize: 14),
            ],
          ),
        ),
      ),
    );
  }
}
