import 'dart:async';

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../state/shop_state.dart';
import '../widgets/product_card.dart';
import 'product_list_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenCart;
  const HomeScreen({super.key, required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final deals = [...products]..sort((a, b) => b.discountPercent.compareTo(a.discountPercent));

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_bag, color: Color(0xFFFFE11B)),
            SizedBox(width: 6),
            Text('ShopEase',
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: shop.cartCount > 0,
              label: Text('${shop.cartCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: onOpenCart,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: InkWell(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SearchScreen())),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Search for products, brands and more',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          _CategoryStrip(),
          const _BannerCarousel(),
          _SectionHeader(
            title: 'Deals of the Day',
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductListScreen(title: 'Deals of the Day', items: deals)),
            ),
          ),
          SizedBox(
            height: 260,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(width: 4),
              itemBuilder: (_, i) => SizedBox(width: 160, child: ProductCard(product: deals[i])),
            ),
          ),
          const _SectionHeader(title: 'Recommended for You'),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 0.62,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 104,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final c = categories[i];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListScreen(
                  title: c.name,
                  items: products.where((p) => p.category == c.name).toList(),
                ),
              ),
            ),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: c.color.withValues(alpha: 0.15),
                    child: Icon(c.icon, color: c.color),
                  ),
                  const SizedBox(height: 6),
                  Text(c.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  static const _banners = [
    ('Big Savings Week', 'Up to 70% off on electronics', Color(0xFF2874F0), Icons.bolt),
    ('Fashion Fiesta', 'Min. 50% off on top brands', Color(0xFFD81B60), Icons.checkroom),
    ('Home Makeover', 'Furniture from ₹999', Color(0xFF6D4C41), Icons.chair),
  ];

  final _controller = PageController();
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      final next = (_page + 1) % _banners.length;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) {
              final (title, subtitle, color, icon) = _banners[i];
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Icon(icon, size: 64, color: Colors.white),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _page ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _page ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  const _SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 8, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (onViewAll != null)
            FilledButton(onPressed: onViewAll, child: const Text('View all')),
        ],
      ),
    );
  }
}
