import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding:
          const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: const Text('Self-Sync Tutorial'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _workoutTutorial(),
                    _progressionTutorial(),
                    _profileTutorial(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            const Spacer(
              flex: 3,
            ),
            Row(
              children: List.generate(
                3,
                (index) => _buildIndicator(index),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () async {
                User user = context.read<UserService>().currentUser;
                if (context.read<UserService>().newUser) {
                  await context.read<UserService>().toggleNewUser(user);
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _workoutTutorial() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  child: const Image(
                    image: AssetImage('lib/assets/workout_tutorial_image.jpg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Workout Page',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Text(
                      '1. Create Workout:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Tap on the plus button in the top right of screen to add a workout',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '2. Tutorial Page:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Tap on the question mark to open tutorial dialog',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '3. Toggle Calendar View:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Tap on the month title and change calendar view',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '4. Edit and Delete Workout:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Slide left on workout to access edit and delete option',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '5. Toggle Completion:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Slide right on workout to access completion option',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressionTutorial() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  child: const Image(
                    image: AssetImage('lib/assets/progress_tutorial_image.jpg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Progression Page',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Text(
                      '1. Completed Workouts:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Shows the amount of workouts you have marked finished',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '2. Workout List:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Shows all the workouts you have created and allows to search through titles',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '3. Body Mass Index (BMI):',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Shows you BMI rating',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTutorial() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Image(
                    image: AssetImage('lib/assets/profile_tutorial_image.jpg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Profile Page',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    Text(
                      '1. Logout:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Button to access the ability to exit your Account',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '2. Edit:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Access to edit your profile',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      '3. Delete:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Text(
                        'Access to completely delete your account (Cannot be undone)',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 10.0,
      height: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.purple : Colors.blue,
      ),
    );
  }
}
