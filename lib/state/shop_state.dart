import 'package:flutter/material.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, [this.quantity = 1]);
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime placedAt;
  final String address;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.placedAt,
    required this.address,
  });
}

/// Simple app-wide state: cart, wishlist and orders (in memory only).
class ShopState extends ChangeNotifier {
  final Map<String, CartItem> _cart = {};
  final Set<String> _wishlist = {};
  final List<Order> _orders = [];

  List<CartItem> get cartItems => _cart.values.toList();
  List<Order> get orders => List.unmodifiable(_orders.reversed);
  Set<String> get wishlist => Set.unmodifiable(_wishlist);

  int get cartCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);
  double get cartMrp =>
      _cart.values.fold(0, (sum, i) => sum + i.product.mrp * i.quantity);
  double get cartTotal =>
      _cart.values.fold(0, (sum, i) => sum + i.product.price * i.quantity);
  double get cartDiscount => cartMrp - cartTotal;
  double get deliveryFee => cartTotal == 0 || cartTotal >= 500 ? 0 : 40;
  double get payable => cartTotal + deliveryFee;

  bool inCart(Product p) => _cart.containsKey(p.id);
  bool isWishlisted(Product p) => _wishlist.contains(p.id);

  void addToCart(Product p) {
    _cart.update(p.id, (i) => i..quantity += 1, ifAbsent: () => CartItem(p));
    notifyListeners();
  }

  void decrement(Product p) {
    final item = _cart[p.id];
    if (item == null) return;
    if (item.quantity <= 1) {
      _cart.remove(p.id);
    } else {
      item.quantity -= 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product p) {
    _cart.remove(p.id);
    notifyListeners();
  }

  void toggleWishlist(Product p) {
    if (!_wishlist.remove(p.id)) _wishlist.add(p.id);
    notifyListeners();
  }

  Order placeOrder(String address) {
    final order = Order(
      id: 'OD${DateTime.now().millisecondsSinceEpoch}',
      items: _cart.values.map((i) => CartItem(i.product, i.quantity)).toList(),
      total: payable,
      placedAt: DateTime.now(),
      address: address,
    );
    _orders.add(order);
    _cart.clear();
    notifyListeners();
    return order;
  }
}

/// Exposes [ShopState] to the widget tree and rebuilds dependents on change.
class ShopScope extends InheritedNotifier<ShopState> {
  const ShopScope({super.key, required ShopState state, required super.child})
      : super(notifier: state);

  static ShopState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!.notifier!;
}

String rupees(num value) {
  final s = value.round().toString();
  if (s.length <= 3) return '₹$s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '₹${parts.join(',')},$last3';
}
