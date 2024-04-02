import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import '../widgets/textfields.dart';
import '../widgets/dialogs.dart';
import '../routes/routes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Self-Sync',
                    style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                ),
                LoginAppTextField(
                  controller: usernameController,
                  labelText: 'Username',
                  hidden: false,
                ),
                LoginAppTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  hidden: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showSnackBar(context,
                            'Please enter the username and password first');
                      } else {
                        String username = usernameController.text.trim();
                        String password = passwordController.text;

                        String usernameResult = await context
                            .read<UserService>()
                            .getUser(usernameController.text.trim());
                        if (usernameResult != 'Ok') {
                          showSnackBar(context, 'Username or Password Invalid');
                        } else {
                          String isPasswordCorrect = await context
                              .read<UserService>()
                              .isPasswordCorrect(username, password);
                          if (isPasswordCorrect != 'Ok') {
                            showSnackBar(
                                context, 'Username or Password Invalid');
                          } else {
                            String username = context
                                .read<UserService>()
                                .currentUser
                                .username;
                            context
                                .read<WorkoutService>()
                                .getWorkouts(username);
                            Navigator.of(context)
                                .pushNamed(RouteManager.workoutPage);
                            usernameController.clear();
                            passwordController.clear();
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Continue'),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                  child: Text('Create a new Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
