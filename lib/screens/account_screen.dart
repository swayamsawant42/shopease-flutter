import 'package:flutter/material.dart';

import '../state/shop_state.dart';
import '../widgets/product_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final orders = shop.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                CircleAvatar(radius: 28, child: Icon(Icons.person, size: 32)),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, Demo User',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('demo@shopease.app', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('My Orders (${orders.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          if (orders.isEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: const Text('No orders yet.', style: TextStyle(color: Colors.grey)),
            ),
          for (final o in orders)
            Container(
              color: Colors.white,
              child: ExpansionTile(
                leading: SizedBox(
                    width: 44, height: 44, child: ProductImage(product: o.items.first.product, size: 24)),
                title: Text(o.items.length == 1
                    ? o.items.first.product.name
                    : '${o.items.first.product.name} +${o.items.length - 1} more',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                subtitle: Text('${rupees(o.total)} • Ordered ${_fmtDate(o.placedAt)}'),
                children: [
                  for (final i in o.items)
                    ListTile(
                      dense: true,
                      title: Text(i.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text('x${i.quantity}  ${rupees(i.product.price * i.quantity)}'),
                    ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(o.address),
                    subtitle: Text('Order ID: ${o.id}'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            child: const Column(
              children: [
                ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Saved Addresses')),
                ListTile(leading: Icon(Icons.card_giftcard), title: Text('Gift Cards')),
                ListTile(leading: Icon(Icons.notifications_none), title: Text('Notifications')),
                ListTile(leading: Icon(Icons.help_outline), title: Text('Help Centre')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}
