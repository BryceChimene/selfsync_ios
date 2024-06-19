import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final VoidCallback showLoginPage;
  final VoidCallback showRegisterPage;

  const LandingPage({
    super.key,
    required this.showLoginPage,
    required this.showRegisterPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: showLoginPage,
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: showRegisterPage,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
