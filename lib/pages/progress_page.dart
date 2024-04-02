import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';
import '../widgets/bmi_chart.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/completed_workouts.dart';
import '../widgets/workout_list.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  DateTime selectedDay = DateTime.now();

  List<Workout> _getEvents(DateTime date) {
    // Fetch workouts for the selected date from WorkoutService
    final workoutsForDate = context.read<WorkoutService>().workouts;
    return workoutsForDate;
  }

  Map<DateTime, int> createTotalCompletedWorkoutMap() {
    // Get the workouts for the selected day
    List<Workout> workouts = _getEvents(selectedDay);

    // Create a map with distinct dates and set the values to 1
    Map<DateTime, int> workoutMap = {};
    for (Workout workout in workouts) {
      DateTime date = DateTime(
        workout.date.year,
        workout.date.month,
        workout.date.day,
      );
      if (workout.done) {
        // Set the value to 2 if at least one workout is done on that date
        workoutMap[date] = 2;
      } else {
        // Set the value to 1 if the workout is not done
        workoutMap.putIfAbsent(date, () => 1);
      }
    }

    return workoutMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //Top Headerbar
      appBar: AppBar(
        title: const Text('Progress Page'),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 29, 26, 49),
        centerTitle: true,
        toolbarHeight: 40,
      ),

      //Bottom navigation bar
      bottomNavigationBar: BottomNavBar(indexNum: 1),

      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 29, 26, 49),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 10,
                    bottom: 10,
                    right: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CompletedWorkouts(),
                      BMIChart(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  child: WorkoutList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
