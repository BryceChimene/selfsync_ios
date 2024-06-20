import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  final VoidCallback showRegisterPage;

  const LandingPage({
    super.key,
    required this.showLoginPage,
    required this.showRegisterPage,
  });

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<LandingPage> {
  int activeIndex = 0;
  int totalIndex = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Main Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: activeIndex > 0
            ? IconButton(
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                ),
                onPressed: () {
                  setState(
                    () {
                      activeIndex--;
                    },
                  );
                },
              )
            : null,
        toolbarHeight: 40,
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: bodyBuilder(),
      ),
    );
  }

  // Switches Steps
  Widget bodyBuilder() {
    switch (activeIndex) {
      case 0:
        return workoutDetails();
      case 1:
        return profileDetails();
      case 2:
        return getStarted();
      default:
        return workoutDetails();
    }
  }

  Widget workoutDetails() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Details about the workout page'),
          GestureDetector(
            onTap: () async {
              setState(() {
                activeIndex++;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileDetails() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Details about the profile page'),
            GestureDetector(
              onTap: () async {
                setState(() {
                  activeIndex++;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getStarted() {
    VoidCallback showLoginPage = widget.showLoginPage;
    VoidCallback showRegisterPage = widget.showRegisterPage;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: showLoginPage,
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: showRegisterPage,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
