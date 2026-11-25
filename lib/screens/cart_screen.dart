import 'package:flutter/material.dart';

import '../state/shop_state.dart';
import '../widgets/product_card.dart';
import 'checkout_screen.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatelessWidget {
  /// Called from the empty state. When null (pushed as a route), pops back.
  final VoidCallback? onShopNow;
  const CartScreen({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final items = shop.cartItems;

    return Scaffold(
      appBar: AppBar(title: Text('My Cart (${shop.cartCount})')),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined, size: 96, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty!', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  const Text('Add items to it now.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: onShopNow ?? () => Navigator.pop(context),
                    child: const Text('Shop now'),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                for (final item in items)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: item.product)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ProductImage(product: item.product, size: 40)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name,
                                        maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(item.product.brand,
                                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    const SizedBox(height: 6),
                                    PriceRow(item.product),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _QtyButton(icon: Icons.remove, onTap: () => shop.decrement(item.product)),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text('${item.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            _QtyButton(icon: Icons.add, onTap: () => shop.addToCart(item.product)),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => shop.removeFromCart(item.product),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Remove'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                PriceDetails(shop: shop),
                const SizedBox(height: 80),
              ],
            ),
      bottomSheet: items.isEmpty
          ? null
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rupees(shop.payable),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('You save ${rupees(shop.cartDiscount)}',
                              style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFB641B),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class PriceDetails extends StatelessWidget {
  final ShopState shop;
  const PriceDetails({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value, {Color? color, bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
              Text(value,
                  style: TextStyle(color: color, fontWeight: bold ? FontWeight.bold : null)),
            ],
          ),
        );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRICE DETAILS',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const Divider(),
          row('Price (${shop.cartCount} items)', rupees(shop.cartMrp)),
          row('Discount', '− ${rupees(shop.cartDiscount)}', color: Colors.green.shade700),
          row('Delivery Charges', shop.deliveryFee == 0 ? 'FREE' : rupees(shop.deliveryFee),
              color: shop.deliveryFee == 0 ? Colors.green.shade700 : null),
          const Divider(),
          row('Total Amount', rupees(shop.payable), bold: true),
        ],
      ),
    );
  }
}
