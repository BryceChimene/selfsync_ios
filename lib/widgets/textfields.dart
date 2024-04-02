import 'package:flutter/material.dart';

class RegisterAppTextField extends StatelessWidget {
  const RegisterAppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hidden,
    this.keyboardtype = TextInputType.text,
    this.padding =
        const EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool hidden;
  final TextInputType keyboardtype;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        obscureText: hidden,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(bottom: 2, left: 10, right: 10, top: 2),
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: Colors.white,
          )),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}

class LoginAppTextField extends StatelessWidget {
  const LoginAppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hidden,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
      child: TextField(
        obscureText: hidden,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
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
          labelText: labelText,
        ),
      ),
    );
  }
}
