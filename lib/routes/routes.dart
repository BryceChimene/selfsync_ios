import 'package:flutter/material.dart';
import '../pages/progress_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
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
          builder: (context) => const LoginPage(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        );

      case workoutPage:
        return MaterialPageRoute(
          builder: (context) => const WorkoutPage(),
        );

      case progressPage:
        return MaterialPageRoute(
          builder: (context) => const ProgressPage(),
        );

      case feedPage:
        return MaterialPageRoute(
          builder: (context) => const FeedPage(),
        );

      case profilePage:
        return MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
