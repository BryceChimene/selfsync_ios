import 'package:flutter/material.dart';
import '../database/selfsync_database.dart';
import '../models/workout.dart';

class WorkoutService with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  Future<String> getWorkouts(String username) async {
    try {
      _workouts = await SelfSyncDatabase.instance.getWorkouts(username);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> deleteWorkout(Workout workout) async {
    try {
      await SelfSyncDatabase.instance.deleteWorkout(workout);
    } catch (e) {
      return e.toString();
    }
    String result = await getWorkouts(workout.username);
    return result;
  }

  Future<String> updateWorkout(Workout workout) async {
    try {
      await SelfSyncDatabase.instance.updateWorkout(workout);
    } catch (e) {
      return e.toString();
    }
    String result = await getWorkouts(workout.username);
    return result;
  }

  Future<Workout> createWorkout(Workout workout) async {
    try {
      await SelfSyncDatabase.instance.createWorkout(workout);
      return workout; // Return the created workout object
    } catch (e) {
      return Future.error(e.toString()); // Return error if creation fails
    }
  }

  Future<String> toggleWorkoutDone(Workout workout) async {
    try {
      await SelfSyncDatabase.instance.toggleWorkoutDone(workout);
    } catch (e) {
      return e.toString();
    }
    String result = await getWorkouts(workout.username);
    return result;
  }
}
