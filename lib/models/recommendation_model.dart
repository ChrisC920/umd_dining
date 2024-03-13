import 'package:flutter/material.dart';

class RecommendationModel {
  String name;
  Color boxColor;
  IconData icon;
  String calories;
  String location;
  bool viewIsSelected;

  RecommendationModel({
    required this.name,
    required this.boxColor,
    required this.icon,
    required this.calories,
    required this.location,
    required this.viewIsSelected,
  });

  static List<RecommendationModel> getRecommendations() {
    List<RecommendationModel> reccomendations = [];

    reccomendations.add(
      RecommendationModel(
        name: 'Omellete',
        boxColor: Colors.yellow,
        icon: Icons.egg,
        calories: '100',
        location: 'All dining halls',
        viewIsSelected: true,
      ),
    );

    reccomendations.add(
      RecommendationModel(
        name: 'Bacon',
        boxColor: Colors.red,
        icon: Icons.breakfast_dining_outlined,
        calories: '200',
        location: '251 North',
        viewIsSelected: false,
      ),
    );

    reccomendations.add(RecommendationModel(
      name: 'French Toast',
      boxColor: Colors.brown,
      icon: Icons.no_food,
      calories: '500',
      location: 'The Y',
      viewIsSelected: false,
    ));

    reccomendations.add(RecommendationModel(
      name: 'Scrambled Eggs',
      boxColor: Colors.orange,
      icon: Icons.apple,
      calories: '90',
      location: 'All dining halls',
      viewIsSelected: false,
    ));

    return reccomendations;
  }
}
