import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout.dart';
import '../services/workout_service.dart';

class CompletedWorkouts extends StatefulWidget {
  const CompletedWorkouts({Key? key}) : super(key: key);

  @override
  _CompletedWorkouts createState() => _CompletedWorkouts();
}

class _CompletedWorkouts extends State<CompletedWorkouts> {
  int completedWorkoutsCount = 0;

  void updateCompletedWorkoutsCount() {
    final List<Workout> workouts = context.read<WorkoutService>().workouts;
    final int count = workouts.where((workout) => workout.done).length;

    setState(() {
      completedWorkoutsCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    updateCompletedWorkoutsCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateCompletedWorkoutsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total\nCompleted',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  '$completedWorkoutsCount',
                  style: const TextStyle(fontSize: 40, color: Colors.purple),
                ),
              ),
              const Text(
                'Workouts',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
