import 'package:flutter/material.dart';

class NavigationModel {
  static List<Widget> getNavigations() {
    List<Widget> navigations = [];

    navigations.add(
      const NavigationDestination(
        icon: Icon(Icons.home),
        label: "Home",
      ),
    );

    navigations.add(
      const NavigationDestination(
        icon: Icon(Icons.favorite),
        label: "Favorites",
      ),
    );

    navigations.add(
      const NavigationDestination(
        icon: Icon(Icons.search),
        label: "Browse",
      ),
    );

    navigations.add(
      const NavigationDestination(
        icon: Icon(Icons.person_2_outlined),
        label: "Profile",
      ),
    );

    return navigations;
  }
}
