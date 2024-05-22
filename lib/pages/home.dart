import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/food_info.dart';
import 'package:umd_dining/utils/constants.dart';
import 'package:umd_dining/models/category_model.dart';

final _data = supabase.from('food').select();
double pos = 115;
double prevpos = 115;
bool hide = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool suggestionsVisible = false;
  late final ScrollController _scrollController;
  final fieldText = TextEditingController();
  List<CategoryModel> categories = CategoryModel.getCategories();

  @override
  void initState() {
    super.initState();
    suggestionsVisible = false;
    hide = false;
    _scrollController = ScrollController();
    _scrollController.addListener(_handleControllerNotification);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _handleControllerNotification() {
    // if (_scrollController.position.userScrollDirection ==
    //     ScrollDirection.forward) {
    //   setState(() {
    //     hide = false;
    //   });
    // }
    // if (_scrollController.position.userScrollDirection ==
    //     ScrollDirection.reverse) {
    //   setState(() {
    //     hide = true;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Main build
    return Scaffold(
      // extendBodyBehindAppBar: true,

      // appBar: appBar(),
      backgroundColor: Colors.white,

      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [appBar()],
        body: ListView(
          // controller: _scrollController,
          // Page Contents
          children: [
            const SizedBox(height: 70),
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
        ),
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedContainer(
        // margin: const EdgeInsets.only(bottom: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          color: Colors.orange,
        ),
        height: suggestionsVisible ? 300 : 55,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
        alignment: Alignment.topCenter,
        // margin: EdgeInsets.only(
        //   top: hide ? 112 : 112,
        // ),
        child: _searchInput(),
      ),
    );
  }

  Stack _searchInput() {
    return Stack(
      children: [
        Container(
          height: 55,
          // Main container
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
            controller: fieldText,
            onTap: () {
              setState(() {
                suggestionsVisible = true;
              });
            },
            onChanged: (_) {
              setState(() {
                suggestionsVisible = true;
              });
            },
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                suggestionsVisible = false;
              });
            },
            onSubmitted: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                suggestionsVisible = false;
              });
            },

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
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suggestionsVisible
                    ? IconButton(
                        onPressed: () {
                          if (fieldText.text == "") {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              suggestionsVisible = false;
                            });
                          }
                          clearInput();
                        },
                        icon: const Icon(Icons.close),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.tune),
                      ),
              ),
              border: suggestionsVisible
                  ? const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      borderSide: BorderSide.none,
                    )
                  : const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(14),
                      ),
                      borderSide: BorderSide.none,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      // backgroundColor: Colors.red,
      pinned: true,
      floating: true,
      snap: true,
      // clipBehavior: Clip.none,

      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(55),
      //   child: _searchField(),
      // ),
      flexibleSpace: OverflowBox(
        maxHeight: 500,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const Text(
              // "UMD Dining Text and styling"
              'UMD Dining',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            _searchField(),
            // OverflowBox(child: _searchField()),
          ],
        ),
      ),

      // bottom: Tab(
      //   height: suggestionsVisible ? 300 : 55,
      //   child: _searchField(),
      // ),
      // title: const Text(
      //   // "UMD Dining Text and styling"
      //   'UMD Dining',
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 24,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      // elevation: 0.0,
      // centerTitle: true,
      // leading: IconButton(
      //   icon: const Icon(
      //     Icons.keyboard_arrow_left,
      //     size: 36,
      //   ),
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 8.0),
      //     child: IconButton(
      //       icon: const Icon(
      //         Icons.person_2_outlined,
      //         size: 32,
      //       ),
      //       onPressed: () {
      //         print('Right press');
      //       },
      //     ),
      //   ),
      // ],
    );
  }

  void clearInput() {
    fieldText.clear();
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
