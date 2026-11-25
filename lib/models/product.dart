import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double mrp;
  final double rating;
  final int reviews;
  final IconData icon;
  final Color color;
  final List<String> highlights;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.mrp,
    required this.rating,
    required this.reviews,
    required this.icon,
    required this.color,
    this.highlights = const [],
  });

  int get discountPercent => (((mrp - price) / mrp) * 100).round();
}

class Category {
  final String name;
  final IconData icon;
  final Color color;

  const Category(this.name, this.icon, this.color);
}
