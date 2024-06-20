import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:selfsync_ios/routes/routes.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../widgets/dialogs.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  GlobalKey<FormState> basicFormKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> basicFormKey2 = GlobalKey<FormState>();
  int activeIndex = 0;
  int totalIndex = 2;

  // First Step
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Second Step
  final _firstNamecontroller = TextEditingController();
  final _lastNameController = TextEditingController();
  final _weightController = TextEditingController();
  bool passwordObscure = true;
  bool confirmPasswordObscure = true;

  String _selectedGender = '';
  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  final _selectedWeightUnits = ValueNotifier('lbs');
  final List<bool> _selectedWeight = <bool>[false, true];
  var weightUnits = ['kgs', 'lbs'];
  String selectedWeight = '';
  String weightUnit = '';

  final _selectedHeightUnits = ValueNotifier('ft');
  final List<bool> _selectedHeight = <bool>[false, true];
  var heightUnits = ['cm', 'ft'];
  String selectedHeight = '';
  String heightUnit = '';
  int currentFt = 5;
  int currentIn = 6;

  DateTime? dateOfBirth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _firstNamecontroller.dispose();
    _lastNameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      // Create User
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add User Details
      addUserDetials(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _firstNamecontroller.text.trim(),
          _lastNameController.text.trim(),
          selectedWeight.trim(),
          selectedHeight.trim(),
          dateOfBirth!,
          _selectedGender);

      showSnackBar(context, 'Accout Successfully Created!');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Email Already Exist.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(context, 'The email address is not valid.');
      } else if (e.code == 'weak-password') {
        showSnackBar(
            context, 'The password is too weak, 7 characters or more.');
      } else {
        showSnackBar(context, e.message.toString());
      }
    } catch (e) {
      showSnackBar(context, 'An unexpected error occured. Please try again.');
    }
  }

  Future addUserDetials(
      String username,
      String email,
      String firstName,
      String lastName,
      String weight,
      String height,
      DateTime dateofBirth,
      String gender) async {
    await FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'email': email,
      'first name': firstName,
      'last name': lastName,
      'weight': weight,
      'height': height,
      'date of birth': dateOfBirth,
      'gender': gender,
    });
  }

  // Return true if username is taken
  Future<bool> checkUsernameExistence(username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  // Return true if email is taken
  Future<bool> checkEmailExistence(email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  // Main Build Method
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (activeIndex != 0) {
          activeIndex--;
          setState(() {});
          return false;
        } 
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: DotStepper(
            activeStep: activeIndex,
            shape: Shape.pipe,
            dotRadius: 40,
            spacing: 40,
            tappingEnabled: false,
            indicatorDecoration: const IndicatorDecoration(
              color: Colors.blueAccent,
              strokeColor: Colors.lightBlueAccent,
            ),
            lineConnectorDecoration: const LineConnectorDecoration(
              strokeWidth: 3,
              color: Colors.white30,
            ),
            lineConnectorsEnabled: true,
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color.fromARGB(255, 66, 65, 65), Color.fromARGB(255, 42, 42, 42)],
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          'lib/assets/logos/selfsync_logo1.png',
                          fit: BoxFit.contain,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 42, 42, 42),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              border: Border(top: BorderSide(color: Colors.black)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white30,
                                  spreadRadius: 7,
                                  blurRadius: 110,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: bodyBuilder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Switches Steps
  Widget bodyBuilder() {
    switch (activeIndex) {
      case 0:
        return basicDetails();
      case 1:
        return personalDetails();
      default:
        return basicDetails();
    }
  }

  // 1st Step
  Widget basicDetails() {
    return Form(
      key: basicFormKey1,
      child: Column(
        children: [
          // Username Field
          _textFormField(
            controller: _usernameController,
            labelText: 'Username',
            validator: RequiredValidator(errorText: 'Requred *'),
          ),
          const SizedBox(height: 15),

          // Email Field
          _textFormField(
            controller: _emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Required *';
              }
              if (!EmailValidator(errorText: 'Not a valid email')
                  .isValid(val)) {
                return 'Not a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Password Field
          _textFormField(
            controller: _passwordController,
            labelText: 'Password',
            obscureText: passwordObscure,
            suffixIcon: IconButton(
              color: Colors.white70,
              icon: passwordObscure
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  passwordObscure = !passwordObscure;
                });
              },
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: 'Requred *'),
              MinLengthValidator(7, errorText: 'Min 7 Charchaters'),
            ]).call,
          ),
          const SizedBox(height: 15),

          // Confirm Password Field
          _textFormField(
            controller: _confirmPasswordController,
            labelText: 'Confrim Password',
            obscureText: confirmPasswordObscure,
            suffixIcon: IconButton(
              color: Colors.white70,
              icon: confirmPasswordObscure
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () async {
                setState(() {
                  confirmPasswordObscure = !confirmPasswordObscure;
                });
              },
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Required *';
              }
              if (val != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Next button
          GestureDetector(
            onTap: () async {
              if (basicFormKey1.currentState?.validate() ?? false) {
                if (!await checkEmailExistence(_emailController.text.trim())) {
                  setState(() {
                    activeIndex++;
                  });
                } else {
                  showSnackBar(context, 'Email already exists.');
                }
              }
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
          const SizedBox(height: 10),

          // Step Counter
          Text(
            'Step ${activeIndex + 1} of $totalIndex',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // Login page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'I am a member!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteManager.loginPage);
                },
                child: const Text(
                  ' Login Now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2nd Step
  Widget personalDetails() {
    return Form(
      key: basicFormKey2,
      child: Column(
        children: [
          // First Name
          _textFormField(
            controller: _firstNamecontroller,
            labelText: 'First Name',
            validator: RequiredValidator(errorText: 'Requred *').call,
          ),
          const SizedBox(height: 15),

          // Last Name
          _textFormField(
            controller: _lastNameController,
            labelText: 'Last Name',
            validator: RequiredValidator(errorText: 'Requred *').call,
          ),
          const SizedBox(height: 15),

          // Weight, Height, & DOB
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Weight
              GestureDetector(
                onTap: () async {
                  _weightModal(context);
                },
                child: Container(
                  width: 115,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          textAlign: TextAlign.left,
                          'Weight:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Text(
                        selectedWeight != '' ? "${selectedWeight}" : "00.0",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              // Height
              GestureDetector(
                onTap: () {
                  _heightModal(context);
                },
                child: Container(
                  width: 115,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          textAlign: TextAlign.left,
                          'Height:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Text(
                        selectedHeight.isNotEmpty
                            ? selectedHeight
                            : (heightUnit == 'cm' ? '0 cm' : "0'00\""),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Date of Birth
              GestureDetector(
                onTap: () {
                  _dateOfBirthModal(context);
                },
                child: Container(
                  width: 115,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          textAlign: TextAlign.left,
                          'DOB: ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Text(
                        dateOfBirth != null
                            ? "${dateOfBirth!.month}/${dateOfBirth!.day}/${dateOfBirth!.year.toString()}"
                            : "--/--/--",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Gender
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGenderButton('Male'),
              _buildGenderButton('Female'),
              _buildGenderButton('Other'),
            ],
          ),
          const SizedBox(height: 15),

          // Signup button
          GestureDetector(
            onTap: () async {
              if (basicFormKey2.currentState?.validate() ?? false) {
                setState(() {
                  signUp();
                });
              }
              ;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Step Counter
          Text(
            'Step ${activeIndex + 1} of $totalIndex',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // Personal Information Dialog
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const AlertDialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 20),
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
            child: const Text(
              'Personal Information?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Standard text field
  Widget _textFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.name,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white70),
        labelText: labelText,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        border: const OutlineInputBorder(
            borderSide: BorderSide(
          width: 1,
          color: Colors.white,
        )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          width: 2,
          color: Colors.blueAccent,
        )),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Gender Button Style
  Widget _buildGenderButton(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Container(
        width: 115,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.white,
            )),
        child: Center(
          child: Text(
            gender,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // Weight Display Sheet
  Future _weightModal(BuildContext context) async {
    showModalBottomSheet(
      showDragHandle: false,
      isDismissible: true,
      backgroundColor: const Color.fromARGB(255, 61, 59, 77),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 350,
              child: Column(
                children: [
                  // Cancel, Title, Save
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedWeight = '';
                              weightUnit = '';
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Text(
                          'Weight',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context, selectedWeight);
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Toggle Metrics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        color: Colors.white,
                        fillColor: Colors.blueAccent,
                        borderColor: Colors.grey,
                        selectedColor: Colors.white,
                        selectedBorderColor: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        isSelected: _selectedWeight,
                        onPressed: (int index) {
                          setModalState(() {
                            for (int i = 0; i < _selectedWeight.length; i++) {
                              _selectedWeight[i] = i == index;
                            }
                            _selectedWeightUnits.value = weightUnits[index];
                          });
                        },
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text('kg'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text('lb'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white38),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Column(
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedWeightUnits,
                          builder: (context, selectedUnits, child) {
                            double minWeight;
                            double maxWeight;

                            if (selectedUnits == 'kgs') {
                              minWeight = 40;
                              maxWeight = 220;
                            } else {
                              // Convert kg to lb and set min and max
                              minWeight = 88; // 1 kg = 2.20462 lb
                              maxWeight = 480;
                            }

                            return AnimatedWeightPicker(
                              min: minWeight,
                              max: maxWeight,
                              division: .1,
                              squeeze: 5,
                              dialColor: Colors.blueAccent,
                              majorIntervalHeight: 30,
                              majorIntervalColor:
                                  const Color.fromARGB(255, 120, 155, 183),
                              subIntervalHeight: 20,
                              selectedValueColor: Colors.blueAccent,
                              suffixText: selectedUnits,
                              suffixTextColor: Colors.blueAccent,
                              onChange: (newValue) {
                                setState(() {
                                  selectedWeight = '$newValue $selectedUnits';
                                  weightUnit = selectedUnits;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Height Display Sheet
  Future _heightModal(BuildContext context) async {
    showModalBottomSheet(
      showDragHandle: false,
      isDismissible: true,
      backgroundColor: const Color.fromARGB(255, 61, 59, 77),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 350,
              child: Column(
                children: [
                  // Cancel, Title, Save
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedHeight = '';
                              heightUnit = '';
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Text(
                          'Height',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        // Save
                        IconButton(
                          onPressed: () {
                            if (_selectedHeightUnits.value == 'ft') {
                              setState(() {
                                selectedHeight = "$currentFt' $currentIn\"";
                                heightUnit = 'ft';
                              });
                            }
                            Navigator.pop(context, selectedHeight);
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Toggle Metrics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        color: Colors.white,
                        fillColor: Colors.blueAccent,
                        borderColor: Colors.grey,
                        selectedColor: Colors.white,
                        selectedBorderColor: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        isSelected: _selectedHeight,
                        onPressed: (int index) {
                          setModalState(() {
                            for (int i = 0; i < _selectedHeight.length; i++) {
                              _selectedHeight[i] = i == index;
                            }
                            _selectedHeightUnits.value = heightUnits[index];
                          });
                        },
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text('cm'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text('ft'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white38),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Column(
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedHeightUnits,
                          builder: (context, selectedUnits, child) {
                            if (selectedUnits == 'cm') {
                              return Column(
                                children: [
                                  AnimatedWeightPicker(
                                    min: 99,
                                    max: 231,
                                    division: 1,
                                    squeeze: 2,
                                    dialColor: Colors.blueAccent,
                                    majorIntervalHeight: 30,
                                    majorIntervalColor: const Color.fromARGB(
                                        255, 120, 155, 183),
                                    subIntervalHeight: 20,
                                    selectedValueColor: Colors.blueAccent,
                                    suffixText: selectedUnits,
                                    suffixTextColor: Colors.blueAccent,
                                    onChange: (value) {
                                      setState(() {
                                        selectedHeight = '$value cm';
                                        heightUnit = selectedUnits;
                                      });
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '$currentFt\' $currentIn\"',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NumberPicker(
                                        value: currentFt,
                                        minValue: 3,
                                        maxValue: 7,
                                        itemCount: 3,
                                        itemHeight: 45,
                                        itemWidth: 60,
                                        haptics: true,
                                        infiniteLoop: true,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        onChanged: (value) {
                                          setModalState(() {
                                            currentFt = value;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'Ft',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      NumberPicker(
                                        value: currentIn,
                                        minValue: 0,
                                        maxValue: 11,
                                        itemCount: 3,
                                        itemHeight: 45,
                                        itemWidth: 50,
                                        haptics: true,
                                        infiniteLoop: true,
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        onChanged: (value) {
                                          setModalState(() {
                                            currentIn = value;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'In',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Date of Birth Display Sheet
  Future _dateOfBirthModal(BuildContext context) async {
    DateTime tempDate = dateOfBirth ?? DateTime.now();

    final newDate = await showModalBottomSheet<DateTime>(
      showDragHandle: false,
      isDismissible: true,
      backgroundColor: const Color.fromARGB(255, 61, 59, 77),
      context: context,
      builder: (context) => SizedBox(
        height: 350,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel
                  IconButton(
                    onPressed: () {
                      setState(() {
                        dateOfBirth = null;
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  // Save
                  IconButton(
                    onPressed: () {
                      //date
                      Navigator.pop(context, tempDate);
                      print(tempDate);
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white38),
            Expanded(
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                  itemExtent: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (newDate != null) {
      setState(() {
        dateOfBirth =
            newDate; // Update the actual duration with the confirmed selection
      });
    }
  }
}
