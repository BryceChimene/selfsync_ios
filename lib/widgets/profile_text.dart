import 'package:flutter/material.dart';

class ProfileText extends StatelessWidget {
  const ProfileText({
    Key? key,
    required this.text,
    this.hidden = false,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.only(
      top: 6,
    ),
  }) : super(key: key);

  final String text; // Store the user object
  final bool hidden;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
