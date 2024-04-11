import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/exercise_service.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import './routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExerciseService(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouteManager.loginPage,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
