import 'package:flutter/material.dart';
import 'package:selfsync_ios/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes/routes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Gives access to the native code
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState() {
    super.initState();
    initialization();
  }

  // Forces splash screen to stay for at least 3 seconds
  void initialization() async{
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
