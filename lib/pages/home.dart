// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/category_model.dart';
import 'package:flutter_application_2/models/recommendation_model.dart';
import 'package:flutter_application_2/models/popular_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _data = Supabase.instance.client.from('food').select();
  List<CategoryModel> categories = [];

  List<RecommendationModel> recommendations = [];

  List<PopularModel> popular = [];

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
    recommendations = RecommendationModel.getRecommendations();
    popular = PopularModel.getPopularModel();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      // body: FutureBuilder<List<Map<String, dynamic>>>(
      //   future: _data,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     final foods = snapshot.data!;
      //     return ListView.builder(
      //       itemCount: foods.length,
      //       itemBuilder: ((context, index) {
      //         final food = foods[index];
      //         return ListTile(
      //           title: Text(food['name']),
      //         );
      //       }),
      //     );
      body: ListView(
        children: [
          _searchField(),
          const SizedBox(height: 40),
          _categoriesSection(),
          const SizedBox(height: 40),
          _recommendedFoods(),
          const SizedBox(height: 40),
          _popularItems(),
          const SizedBox(height: 40),
        ],
      ),
      //     },
      //   ),
    );
  }

  Column _popularItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Popular',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          itemCount: popular.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 25),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color: popular[index].boxIsSelected
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: popular[index].boxIsSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xff1D1617).withOpacity(0.07),
                          offset: const Offset(0, 10),
                          blurRadius: 40,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Icon(
                          popular[index].icon,
                          size: 50,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            popular[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${popular[index].calories} | ${popular[index].location}",
                            style: const TextStyle(
                              color: Color(0xff7B6F72),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.expand_circle_down_outlined, size: 40),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Column _recommendedFoods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Recommended\nFoods',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 240,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 210,
                decoration: BoxDecoration(
                  color: recommendations[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      recommendations[index].icon,
                      size: 90,
                    ),
                    Column(
                      children: [
                        Text(
                          recommendations[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${recommendations[index].calories} | ${recommendations[index].location}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 45,
                      width: 130,
                      child: Center(
                        child: Text(
                          'View',
                          style: TextStyle(
                            color: recommendations[index].viewIsSelected
                                ? Colors.white
                                : const Color(0xffC588F2),
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            recommendations[index].viewIsSelected
                                ? const Color(0xff9DCEFF)
                                : Colors.transparent,
                            recommendations[index].viewIsSelected
                                ? const Color(0xff92A3FD)
                                : Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemCount: recommendations.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
          ),
        ),
      ],
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 120,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              width: 25,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(categories[index].icon),
                    ),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.search),
          ),
          hintText: 'Search Items',
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: SizedBox(
            width: 100,
            child: const IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.tune),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'UMD Dining',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          print('Left press');
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.density_medium, size: 25),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_2_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
