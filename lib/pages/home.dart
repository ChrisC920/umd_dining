import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/food_info.dart';
import 'package:umd_dining/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _data = supabase.from('food').select();

  @override
  Widget build(BuildContext context) {
    // Main build
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        // Page Contents
        children: [
          _searchField(),
          const SizedBox(height: 20), // Spacing
          RecommendedFoodWidget(data: _data), // Recommended Food
          const SizedBox(height: 40), // Spacing
          PopularFoodsWidget(data: _data), // Popular Food
          const SizedBox(height: 40), // Spacing
        ],
      ),
    );
  }

  Container _searchField() {
    return Container(
      // Main container
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        // Outter drop shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: TextField(
        // Text input
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.search),
          ),
          hintText: 'Search',
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: const SizedBox(
            width: 100,
            child: IntrinsicHeight(
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
        // "UMD Dining Text and styling"
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
        // Back arrow
        onTap: () {
          print('Left press');
          Navigator.pop(context, context);
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back, size: 25),
        ),
      ),
      actions: [
        // Profile thing
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

class PopularFoodsWidget extends StatelessWidget {
  const PopularFoodsWidget({
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
            const Padding(
              // "Popular Text and styling"
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
              // Load list of popular foods
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemCount: foods.length,
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
                itemCount: foods.length,
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
