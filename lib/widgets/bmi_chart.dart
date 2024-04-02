import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../services/user_service.dart';

class GaugePainter extends CustomPainter {
  final double value;

  GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height;

    // Define categories and colors
    List<BMICategory> categories = [
      BMICategory(color: Colors.blue, start: 0, end: 18.4),
      BMICategory(color: Colors.green, start: 18.5, end: 24.9),
      BMICategory(color: Colors.yellow, start: 25.0, end: 29.9),
      BMICategory(color: Colors.red, start: 30.0, end: 50),
    ];

    // Draw sections with different colors
    for (BMICategory category in categories) {
      double startAngle = pi + (pi * category.start / 50.0);
      double endAngle = pi + (pi * category.end / 50.0);

      Paint sectionPaint = Paint()
        ..color = category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20.0;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        sectionPaint,
      );
    }

    // Draw the needle
    double needleAngle = pi + (pi * value / 50.0);
    double needleLength = radius; // Adjust the length of the needle
    double needleX = centerX + needleLength * cos(needleAngle);
    double needleY = centerY + needleLength * sin(needleAngle);

    Paint needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawLine(
        Offset(centerX, centerY), Offset(needleX, needleY), needlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BMICategory {
  final Color color;
  final double start;
  final double end;

  BMICategory({required this.color, required this.start, required this.end});
}

class GaugeWidget extends StatelessWidget {
  final double value;

  GaugeWidget({required this.value});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 50,
        child: CustomPaint(
          painter: GaugePainter(value: value),
        ),
      ),
    );
  }
}

class BMIChart extends StatefulWidget {
  const BMIChart({Key? key}) : super(key: key);

  @override
  _BMIChartState createState() => _BMIChartState();
}

class _BMIChartState extends State<BMIChart> {
  double calculateBMI() {
    double bmiValue;
    double heightMeters =
        (context.read<UserService>().currentUser.heightFt * 0.3048) +
            (context.read<UserService>().currentUser.heightIn * 0.0254);
    double weightKilograms =
        context.read<UserService>().currentUser.weight * 0.453592;

    bmiValue = weightKilograms / (heightMeters * heightMeters);
    return bmiValue;
  }

  String bmiStatus() {
    String status;
    if (calculateBMI() < 18.5) {
      status = 'Underweight';
    } else if (calculateBMI() >= 18.5 && calculateBMI() < 25) {
      status = 'Healthy Weight';
    } else if (calculateBMI() >= 25 && calculateBMI() < 30) {
      status = 'Overweight';
    } else {
      status = 'Obese';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25, top: 5),
            child: Text(
              bmiStatus(),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          GaugeWidget(value: calculateBMI()),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 0),
            child: Text(
              'Your BMI: ${calculateBMI().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.purple,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: AlertDialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 10),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Body Mass Index (BMI)',
                        textAlign: TextAlign.center,
                      ),
                      content: const SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '10.0 to 18.8: Underweight\n' +
                                    '18.5 to 24.9: Healthy Weight\n' +
                                    '25.0 to 29.9: Overweight\n' +
                                    '30.0 and up: Obese',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.purple),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 5, top: 10, left: 10, right: 10),
                              child: Text(
                                  'BMI is a measurement of your height and weight' +
                                      ' to speculate if your weight is healthy.'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 10, right: 10, left: 10),
                              child: Text(
                                  'Note:\nMuscle is much denser than fat,' +
                                      ' therefore very muscular people may be' +
                                      ' classified as obese.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text('About'),
          ),
        ],
      ),
    );
  }
}
