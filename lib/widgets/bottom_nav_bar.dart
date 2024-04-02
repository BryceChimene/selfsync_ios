// ignore_for_file: must_be_immutable

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../routes/routes.dart';

class BottomNavBar extends StatelessWidget {
  int indexNum = 0;

  BottomNavBar({required this.indexNum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        index: indexNum,
        color: Colors.blueAccent,
        backgroundColor: Color.fromARGB(255, 29, 26, 49),
        height: 60,
        items: const [
          Icon(
            Icons.fitness_center,
            size: 17,
            color: Colors.black,
          ),
          Icon(
            Icons.self_improvement,
            size: 17,
            color: Colors.black,
          ),
          Icon(
            Icons.feed,
            size: 17,
            color: Colors.black,
          ),
          Icon(
            Icons.person,
            size: 17,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed(RouteManager.workoutPage);
          } else if (index == 1) {
            Navigator.of(context).pushNamed(RouteManager.progressPage);
          } else if (index == 2) {
            Navigator.of(context).pushNamed(RouteManager.feedPage);
          } else if (index == 3) {
            Navigator.of(context).pushNamed(RouteManager.profilePage);
          }
        });
  }
}
