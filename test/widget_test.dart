import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopease_app/data/dummy_data.dart';
import 'package:shopease_app/main.dart';
import 'package:shopease_app/state/shop_state.dart';

void main() {
  group('ShopState', () {
    test('adds, increments, decrements and removes cart items', () {
      final shop = ShopState();
      final p = products.first;
      shop.addToCart(p);
      shop.addToCart(p);
      expect(shop.cartCount, 2);
      expect(shop.cartTotal, p.price * 2);
      shop.decrement(p);
      expect(shop.cartCount, 1);
      shop.decrement(p);
      expect(shop.cartItems, isEmpty);
    });

    test('delivery fee applies under ₹500 only', () {
      final shop = ShopState();
      final cheap = products.firstWhere((p) => p.price < 500);
      shop.addToCart(cheap);
      expect(shop.deliveryFee, 40);
      shop.addToCart(products.first);
      expect(shop.deliveryFee, 0);
    });

    test('placing an order clears the cart and records it', () {
      final shop = ShopState()..addToCart(products.first);
      final order = shop.placeOrder('Somewhere');
      expect(shop.cartItems, isEmpty);
      expect(shop.orders.single.id, order.id);
    });

    test('wishlist toggles', () {
      final shop = ShopState();
      shop.toggleWishlist(products.first);
      expect(shop.isWishlisted(products.first), isTrue);
      shop.toggleWishlist(products.first);
      expect(shop.isWishlisted(products.first), isFalse);
    });
  });

  test('rupee formatting uses Indian grouping', () {
    expect(rupees(999), '₹999');
    expect(rupees(18999), '₹18,999');
    expect(rupees(1234567), '₹12,34,567');
  });

  testWidgets('home screen renders and adds to cart from detail page', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    await tester.pumpWidget(ShopEaseApp(state: ShopState()));
    expect(find.text('ShopEase'), findsOneWidget);
    expect(find.text('Deals of the Day'), findsOneWidget);

    final target = find.text(products.first.name).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
    await tester.tap(find.text('ADD TO CART'));
    await tester.pump();
    expect(find.text('GO TO CART'), findsOneWidget);
  });
}
