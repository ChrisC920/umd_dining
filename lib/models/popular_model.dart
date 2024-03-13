import 'package:flutter/material.dart';

class PopularModel {
  String name;
  IconData icon;
  String calories;
  String location;
  bool boxIsSelected;

  PopularModel({
    required this.name,
    required this.icon,
    required this.calories,
    required this.location,
    required this.boxIsSelected,
  });

  static List<PopularModel> getPopularModel() {
    List<PopularModel> popularModel = [];

    popularModel.add(PopularModel(
      name: 'Blueberry Pancake',
      icon: Icons.pan_tool_alt_outlined,
      calories: '420',
      location: 'The Y',
      boxIsSelected: true,
    ));

    popularModel.add(PopularModel(
      name: 'Fish and chips',
      icon: Icons.donut_large,
      calories: '500',
      location: 'South dining',
      boxIsSelected: false,
    ));

    popularModel.add(PopularModel(
      name: 'Temporary Item',
      icon: Icons.water,
      calories: '300',
      location: '251 North',
      boxIsSelected: false,
    ));

    popularModel.add(PopularModel(
      name: 'Temporary Item 2',
      icon: Icons.water,
      calories: '300',
      location: '251 North',
      boxIsSelected: false,
    ));

    return popularModel;
  }
}
