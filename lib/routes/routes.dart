import 'package:flutter/material.dart';
import '../pages/progress_page.dart';
import '../pages/login.dart';
import '../pages/register.dart';
import '../pages/workout_page.dart';
import '../pages/profile_page.dart';
import '../pages/feed_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String workoutPage = '/workoutPage';
  static const String progressPage = '/progressPage';
  static const String feedPage = '/feedPage';
  static const String profilePage = '/profilePage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );

      case workoutPage:
        return MaterialPageRoute(
          builder: (context) => WorkoutPage(),
        );

      case progressPage:
        return MaterialPageRoute(
          builder: (context) => ProgressPage(),
        );

      case feedPage:
        return MaterialPageRoute(
          builder: (context) => FeedPage(),
        );

      case profilePage:
        return MaterialPageRoute(
          builder: (context) => ProfilePage(),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
