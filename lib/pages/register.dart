import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/dialogs.dart';
import '../widgets/textfields.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late String selectedGender = 'Male';
  late TextEditingController heightFtController;
  late TextEditingController heightInController;
  late TextEditingController weightController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    heightFtController = TextEditingController();
    heightInController = TextEditingController();
    weightController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    heightFtController.dispose();
    heightInController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple, Colors.blue],
            )),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 50),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                            color: Colors.white),
                      ),
                    ),
                    Focus(
                      onFocusChange: (value) async {
                        if (!value) {
                          String result = await context
                              .read<UserService>()
                              .checkIfUserExists(
                                  usernameController.text.trim());
                          if (result == 'Ok') {
                            context.read<UserService>().userExists = true;
                          } else {
                            context.read<UserService>().userExists = false;
                            if (!result.contains('not found in the database')) {
                              showSnackBar(context, result);
                            }
                          }
                        }
                      },
                      child: RegisterAppTextField(
                        controller: usernameController,
                        labelText: 'Username',
                        hidden: false,
                      ),
                    ),
                    Selector<UserService, bool>(
                      selector: (context, value) => value.userExists,
                      builder: (context, value, child) {
                        return value
                            ? const Text(
                                'username exists, please choose another',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                              )
                            : Container();
                      },
                    ),
                    RegisterAppTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hidden: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          child: RegisterAppTextField(
                            controller: nameController,
                            labelText: 'Profile Name',
                            hidden: false,
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 20, right: 10),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 0, right: 20),
                            iconSize: 15,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Gender',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                  bottom: 2, left: 10, right: 10, top: 2),
                            ),
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: Colors.blueAccent,
                            isExpanded: true,
                            value: selectedGender,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
                            },
                            items:
                                <String>['Male', 'Female'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Text(
                            'Height:',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6, bottom: 6, left: 0, right: 1),
                          child: SizedBox(
                            width: 45,
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: heightFtController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Ft',
                                labelText: 'Feet',
                                contentPadding: EdgeInsets.only(
                                    bottom: 2, left: 10, right: 10, top: 2),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6, bottom: 6, left: 0, right: 8),
                          child: SizedBox(
                            width: 45,
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: heightInController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'In',
                                labelText: 'Inch',
                                contentPadding: EdgeInsets.only(
                                    bottom: 2, left: 10, right: 10, top: 2),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 0, right: 20),
                            child: TextField(
                              controller: ageController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    bottom: 2, left: 10, right: 10, top: 2),
                                labelText: 'Age',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 8),
                          child: Text(
                            'Weight:',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6, bottom: 6, left: 0, right: 8),
                          child: SizedBox(
                            width: 92,
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Lb',
                                labelText: 'In Pounds',
                                contentPadding: EdgeInsets.only(
                                    bottom: 2, left: 10, right: 10, top: 2),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                )),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 6, left: 0, right: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size.fromWidth(150), backgroundColor: Colors.purple),
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (usernameController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    nameController.text.isEmpty ||
                                    heightFtController.text.isEmpty ||
                                    heightInController.text.isEmpty ||
                                    weightController.text.isEmpty ||
                                    ageController.text.isEmpty) {
                                  showSnackBar(
                                    context,
                                    'Please enter all fields correctly!',
                                  );
                                } else if ((int.tryParse(heightInController.text
                                                .trim()) ??
                                            0) <
                                        0 ||
                                    (int.tryParse(heightInController.text
                                                .trim()) ??
                                            0) >
                                        11) {
                                  showSnackBar(context,
                                      'Please enter a valid inch value (0-11).');
                                } else {
                                  User user = User(
                                    username: usernameController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim(),
                                    gender: selectedGender.trim(),
                                    heightFt: int.tryParse(
                                            heightFtController.text.trim()) ??
                                        0,
                                    heightIn: int.tryParse(
                                            heightInController.text.trim()) ??
                                        0,
                                    weight: double.tryParse(
                                            weightController.text.trim()) ??
                                        0.0,
                                    age: int.tryParse(
                                            ageController.text.trim()) ??
                                        0,
                                  );
                                  String result = await context
                                      .read<UserService>()
                                      .createUser(user);
                                  if (result != 'Ok') {
                                    showSnackBar(context, result);
                                  } else {
                                    showSnackBar(context,
                                        'New account successfully created!');
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextButton(
                        child: const Text(
                          'Personal Information?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  title: Text(
                                    'Personal Information',
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                  content: Text(
                                    'We request the following information to ' +
                                        'provide you with a standing for the ' +
                                        'Body Mass Index (BMI)',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Selector<UserService, bool>(
            selector: (context, value) => value.busyCreate,
            builder: (context, value, child) {
              return value ? const AppProgressIndicator() : Container();
            },
          ),
        ],
      ),
    );
  }
}

//loading screen
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      child: const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.purple,
        ),
      ),
    );
  }
}
