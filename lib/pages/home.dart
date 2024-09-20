import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/food_info.dart';
import 'package:umd_dining/utils/constants.dart';
import 'package:umd_dining/models/category_model.dart';
import 'package:umd_dining/models/navigation_model.dart';

final _data = supabase.from('food').select();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  List<CategoryModel> categories = CategoryModel.getCategories();
  List<Widget> navigations = NavigationModel.getNavigations();
  String searchValue = '';
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Main build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "UMD Dining",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 24,
                weight: 24,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        destinations: navigations,
        indicatorColor: Colors.amber,
        // indicatorShape: const CircleBorder(),
        selectedIndex: currentPageIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
      ),
      body: SafeArea(
        child: <Widget>[
          HomeNavigation(
            scrollController: _scrollController,
            categories: categories,
          ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
          const ProfileNavigation(),
        ][currentPageIndex],
      ),
    );
  }

  // Future<List<String>> _fetchSuggestions(String searchValue) async {
  //   await Future.delayed(const Duration(milliseconds: 750));

  //   return _suggestions.where((element) {
  //     return element.toLowerCase().contains(searchValue.toLowerCase());
  //   }).toList();
  // }
  Future<List<String>> _fetchSuggestions(String searchValue) async {
    try {
      final result =
          await supabase.from('food').select().textSearch('name', searchValue);
      // .limit(100);

      final List<String> names = [];
      for (var v in result.toList()) {
        names.add(v.toString());
      }
      return names;
    } catch (error) {
      print(error);
      return [];
    }
  }
}

class ProfileNavigation extends StatelessWidget {
  const ProfileNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }
}

class HomeNavigation extends StatelessWidget {
  const HomeNavigation({
    super.key,
    required ScrollController scrollController,
    required this.categories,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,

      // Page Contents
      children: [
        const SizedBox(height: 40),
        // Spacing
        SizedBox(
          height: 90,
          width: 400,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: categories[index].boxColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      categories[index].icon,
                    ),
                  ),
                  Text(
                    categories[index].name,
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 30,
                height: 30,
              );
            },
            itemCount: categories.length,
          ),
        ),
        const SizedBox(height: 20),
        RecommendedFoodWidget(data: _data), // Recommended Food
        const SizedBox(height: 40), // Spacing
        PopularFoodsWidget(data: _data), // Popular Food
        const SizedBox(height: 40), // Spacing
      ],
    );
  }
}

class PopularFoodsWidget extends StatelessWidget {
  PopularFoodsWidget({
    super.key,
    required PostgrestFilterBuilder<PostgrestList> data,
  }) : _data = data;

  final PostgrestFilterBuilder<PostgrestList> _data;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Build supabase data
      future: _data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Loading thing
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final foods = snapshot.data!;
        return Column(
          children: [
            const Padding(
              // "Popular Text and styling"
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    'Popular',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ListView.separated(
              // Load list of popular foods
              // physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemCount: 10,
              shrinkWrap: true,

              separatorBuilder: (context, index) => const SizedBox(height: 25),
              itemBuilder: (context, index) {
                final food = foods[index];
                return GestureDetector(
                  // Reroute on click
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FoodInfoPage()),
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff1D1617).withOpacity(0.07),
                            offset: const Offset(0, 10),
                            blurRadius: 40,
                            spreadRadius: 0,
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Icon(
                                  Icons.food_bank,
                                  size: 50,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        "${food['dining_hall']} | ${food['calories_per_serving']} calories | ${food['total_fat']} fats | ${food['total_carbohydrates']} carbohydrates | ${food['protein']} protein",
                                        style: const TextStyle(
                                          color: Color(0xff7B6F72),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.expand_circle_down_outlined,
                                size: 40),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class RecommendedFoodWidget extends StatelessWidget {
  const RecommendedFoodWidget({
    super.key,
    required PostgrestFilterBuilder<PostgrestList> data,
  }) : _data = data;

  final PostgrestFilterBuilder<PostgrestList> _data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Build supabase data
      future: _data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Loading thing
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final foods = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recommended food contents
            const Padding(
              // "Recommended Text and styling"
              padding: EdgeInsets.only(bottom: 10, left: 20),
              child: Text(
                'Recommended',
                textAlign: TextAlign.start,
                style: TextStyle(
                  // Styling
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              // Food item list styling
              height: 250,
              child: ListView.separated(
                // List generator
                separatorBuilder: (context, index) => const SizedBox(width: 25),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: 10,
                itemBuilder: ((context, index) {
                  final food = foods[index];
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FoodInfoPage())),
                    },
                    child: Container(
                      // Food item styling
                      width: 210,
                      decoration: BoxDecoration(
                        // Overall styling
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Contents styling
                          const Icon(
                            // Placeholder Icon
                            Icons.add_box,
                            size: 90,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  // Temporary name text
                                  food['name'],
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    // Temporary text styling
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                Wrap(
                                  // Temporary information text
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      '${food['dining_hall']} | ${food['calories_per_serving']} calories | ${food['total_fat']} fats | ${food['total_carbohydrates']} carbohydrates | ${food['protein']} protein',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 130,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff9DCEFF)],
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
