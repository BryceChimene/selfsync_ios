import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/landing_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Initially, show the landing page
  bool showLandingPage = true;
  bool showLoginPage = false;
  bool showRegisterPage = false;

  void showLogin() {
    setState(() {
      showLandingPage = false;
      showLoginPage = true;
      showRegisterPage = false;
    });
  }

  void showRegister() {
    setState(() {
      showLandingPage = false;
      showLoginPage = false;
      showRegisterPage = true;
    });
  }

  void showLanding() {
    setState(() {
      showLandingPage = true;
      showLoginPage = false;
      showRegisterPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLandingPage) {
      return LandingPage(showLoginPage: showLogin, showRegisterPage: showRegister);
    } else if (showLoginPage) {
      return LoginPage();
    } else {
      return RegisterPage();
    }
  }
}
