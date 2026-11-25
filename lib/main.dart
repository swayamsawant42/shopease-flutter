import 'package:flutter/material.dart';

import 'screens/account_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/home_screen.dart';
import 'screens/wishlist_screen.dart';
import 'state/shop_state.dart';

const brandBlue = Color(0xFF2874F0);
const brandYellow = Color(0xFFFFE11B);

void main() {
  runApp(ShopEaseApp(state: ShopState()));
}

class ShopEaseApp extends StatelessWidget {
  final ShopState state;
  const ShopEaseApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ShopScope(
      state: state,
      child: MaterialApp(
        title: 'ShopEase',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: brandBlue, primary: brandBlue),
          scaffoldBackgroundColor: const Color(0xFFF1F3F6),
          appBarTheme: const AppBarTheme(
            backgroundColor: brandBlue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final pages = [
      HomeScreen(onOpenCart: () => _goTo(3)),
      const CategoriesScreen(),
      const WishlistScreen(),
      CartScreen(onShopNow: () => _goTo(0)),
      const AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          const NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Categories'),
          const NavigationDestination(
              icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Wishlist'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: shop.cartCount > 0,
              label: Text('${shop.cartCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: shop.cartCount > 0,
              label: Text('${shop.cartCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
              icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
