import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  IconData icon;
  MaterialColor boxColor;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Desserts',
        icon: Icons.cake_outlined,
        boxColor: Colors.yellow,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Breakfast',
        icon: Icons.breakfast_dining,
        boxColor: Colors.green,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Asian',
        icon: Icons.ramen_dining,
        boxColor: Colors.purple,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Burgers',
        icon: Icons.fastfood,
        boxColor: Colors.cyan,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Fruits',
        icon: Icons.apple_rounded,
        boxColor: Colors.cyan,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Protein',
        icon: Icons.favorite_border_sharp,
        boxColor: Colors.cyan,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'New',
        icon: Icons.new_releases_outlined,
        boxColor: Colors.cyan,
      ),
    );

    return categories;
  }
}
