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
        name: 'Breakfast',
        icon: Icons.free_breakfast_outlined,
        boxColor: Colors.yellow,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Lunch',
        icon: Icons.lunch_dining_outlined,
        boxColor: Colors.green,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Dinner',
        icon: Icons.dinner_dining_outlined,
        boxColor: Colors.purple,
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Other',
        icon: Icons.food_bank_outlined,
        boxColor: Colors.cyan,
      ),
    );

    return categories;
  }
}
