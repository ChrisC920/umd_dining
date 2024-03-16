import 'dart:ui';

import 'package:flutter/material.dart';

class FoodInfoPage extends StatelessWidget {
  const FoodInfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: appBar(context),
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 80.0),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: appBar(context),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/orange_chicken.jpg',
              fit: BoxFit.cover,
            ),
            ClipRRect(
              // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Placeholder Text',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          NutritionText(text: 'Section: _________'),
                          NutritionText(
                              text: 'Served during: Breakfast, Lunch'),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Nutrition',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          NutritionText(text: '# Calories per serving'),
                          NutritionText(text: 'Serving size: ________'),
                          NutritionText(text: 'Protein: _____'),
                          NutritionText(text: 'Carbohydrates: _____'),
                          NutritionText(text: 'Total Fats: _____'),
                          Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: NutritionText(text: 'Trans Fats: _____'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: NutritionText(text: 'Saturated Fats: _____'),
                          ),
                          NutritionText(text: 'Cholesterol: _____'),
                          NutritionText(text: 'Sodium: _____'),
                          NutritionText(text: 'Dietary Fibers: _____'),
                          NutritionText(text: 'Total Sugars: _____'),
                          Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: NutritionText(text: 'Added Sugars: ____'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container appBar(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, 0.6),
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0),
          ],
        ),
      ),
      child: AppBar(
        title: const Text(
          'UMD Dining',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              print('Right press');
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_2_outlined,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionText extends StatelessWidget {
  const NutritionText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
