import 'package:flutter/material.dart';
import 'package:selfsync_ios/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes/routes.dart';

void main() async {
  // Gives access to the native code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
