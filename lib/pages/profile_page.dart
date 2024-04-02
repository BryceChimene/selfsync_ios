import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../routes/routes.dart';
import '../services/user_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/dialogs.dart';
import '../widgets/profile_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late String selectedGender = 'Male';
  late TextEditingController heightFtController;
  late TextEditingController heightInController;
  late TextEditingController weightController;
  late TextEditingController ageController;

  @override
  void initState() {
    nameController = TextEditingController();
    heightFtController = TextEditingController();
    heightInController = TextEditingController();
    weightController = TextEditingController();
    ageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    heightFtController.dispose();
    heightInController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void showEditProfileDialog() {
    final currentUser = context.read<UserService>().currentUser;

    nameController = TextEditingController(text: currentUser.name);
    selectedGender = currentUser.gender;
    heightFtController =
        TextEditingController(text: currentUser.heightFt.toString());
    heightInController =
        TextEditingController(text: currentUser.heightIn.toString());
    weightController =
        TextEditingController(text: currentUser.weight.toString());
    ageController = TextEditingController(text: currentUser.age.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.only(bottom: 40, top: 40, right: 15, left: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          scrollable: true,
          actionsPadding: const EdgeInsets.only(top: 0, bottom: 0),
          contentPadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          labelStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.only(bottom: 6, left: 10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        value: selectedGender,
                        iconSize: 15,
                        padding: const EdgeInsets.only(right: 5, top: 15),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 15),
                        child: TextFormField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.only(left: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 5),
                        child: TextFormField(
                          controller: heightFtController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Height (ft)',
                            labelStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.only(left: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
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
                        padding: const EdgeInsets.only(top: 15, right: 5),
                        child: TextFormField(
                          controller: heightInController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Height (In)',
                            labelStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.only(left: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
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
                        padding: const EdgeInsets.only(top: 15, left: 5),
                        child: TextFormField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight (lb)',
                            labelStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.only(left: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
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
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog without saving
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: TextButton(
                onPressed: () {
                  if ((int.tryParse(heightInController.text.trim()) ?? 0) < 0 ||
                      (int.tryParse(heightInController.text.trim()) ?? 0) >
                          11) {
                    showSnackBar(
                        context, 'Please enter a valid inch value (0-11).');
                  } else {
                    context.read<UserService>().updateUser(
                          name: nameController.text,
                          gender: selectedGender,
                          heightFt: heightFtController.text,
                          heightIn: heightInController.text,
                          weight: weightController.text,
                          age: ageController.text,
                        );

                    Navigator.of(context).pop();
                    setState(() {});
                    showSnackBar(context, 'Profile successfully updated');
                  }
                  ;
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      bottomNavigationBar: BottomNavBar(indexNum: 3),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) {
                    return Text(
                      value.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) {
                    return Text(
                      '@${value.username}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const ProfileText(
                          text: 'Height:',
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Selector<UserService, User>(
                            selector: (context, value) => value.currentUser,
                            builder: (context, value, child) {
                              return Text(
                                '${value.heightFt}\' ${value.heightIn}\'\'',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        const ProfileText(
                          text: 'Age:',
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Selector<UserService, User>(
                            selector: (context, value) => value.currentUser,
                            builder: (context, value, child) {
                              return Text(
                                '${value.age}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            child: const Text("Logout"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.purple,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    titlePadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    actionsPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    title: const Text('Logout'),
                                    content: const Text(
                                      'Are you sure you want to logout?',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.purple,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.purple,
                                        ),
                                        onPressed: () {
                                          context.read<UserService>().logout();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.loginPage);
                                          showSnackBar(context,
                                              'Successfully logged out!');
                                        },
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const ProfileText(
                          text: 'Gender:',
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Selector<UserService, User>(
                            selector: (context, value) => value.currentUser,
                            builder: (context, value, child) {
                              return Text(
                                value.gender,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        const ProfileText(
                          text: 'Weight:',
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Selector<UserService, User>(
                            selector: (context, value) => value.currentUser,
                            builder: (context, value, child) {
                              return Text(
                                '${value.weight}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              showEditProfileDialog();
                            },
                            child: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.purple,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 30, right: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  child: const Text("Delete Account"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red, elevation: 10,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 160),
                          titlePadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          actionsPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          title: const Text('Delete'),
                          content: const Column(
                            children: [
                              Text(
                                'Are you sure you want to DELETE this account?',
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'This cannot be undone.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.purple,
                              ),
                              onPressed: () async {
                                String usernameToDelete = context
                                    .read<UserService>()
                                    .currentUser
                                    .username;

                                String result = await context
                                    .read<UserService>()
                                    .deleteUser(usernameToDelete);

                                if (result == 'Ok') {
                                  Navigator.of(context)
                                      .pushNamed(RouteManager.loginPage);
                                  showSnackBar(
                                      context, 'Account Deleted Successfully!');
                                } else {
                                  print('Error deleting account: $result');
                                  // Optionally, show an error message to the user
                                  showSnackBar(context,
                                      'Error deleting account: $result');
                                }
                              },
                              child: const Text('Delete'),
                            ),
                          ],
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
    );
  }
}
