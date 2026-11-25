# ShopEase 🛍️

A dummy online shopping app built with Flutter — a demo e-commerce UI with a cart, wishlist and checkout flow. All products, prices and orders are fake and kept in memory; no backend or real payments.

## Features

- **Home** — search bar, category strip, auto-scrolling offer banners, "Deals of the Day" and a recommended products grid
- **Categories** — browse products by category, with sorting (price, rating, discount)
- **Search** — live search by product name, brand or category
- **Product details** — highlights, description, rating, MRP / discount, Add to Cart & Buy Now
- **Wishlist** — save products with the heart icon
- **Cart** — change quantities, remove items, price breakdown with savings and delivery fee (free above ₹500)
- **Checkout** — address form with validation, demo payment options, order success screen
- **Account** — order history

## Tech

- Flutter (Material 3), no third-party packages
- State management with `ChangeNotifier` + `InheritedNotifier`
- Product images are drawn with Material icons, so the app works fully offline

## Project structure

```
lib/
├── main.dart                 # App entry, theme, bottom navigation
├── data/dummy_data.dart      # Fake categories & products
├── models/product.dart
├── state/shop_state.dart     # Cart, wishlist, orders
├── widgets/product_card.dart
└── screens/                  # home, categories, search, product detail,
                              # cart, checkout, wishlist, account
```

## Run it

```bash
flutter pub get
flutter run            # Android / iOS
flutter run -d chrome  # Web
```

## Test

```bash
flutter test
```

> This is a learning/demo project and is not affiliated with any real shopping platform.
