import 'package:flutter/material.dart';
import '../database/selfsync_database.dart';
import '../models/exercise.dart';

class ExerciseService with ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  Future<String> getExercises(int workoutId) async {
    try {
      _exercises = await SelfSyncDatabase.instance.getExercises(workoutId);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'Ok';
  }

  Future<String> deleteExercise(Exercise exercise) async {
    try {
      await SelfSyncDatabase.instance.deleteExercise(exercise);
    } catch (e) {
      return e.toString();
    }
    String result = await getExercises(exercise.workoutId);
    return result;
  }

  Future<String> updateExercise(Exercise exercise) async {
    try {
      await SelfSyncDatabase.instance.updateExercise(exercise);
    } catch (e) {
      return e.toString();
    }
    String result = await getExercises(exercise.workoutId);
    return result;
  }

  Future<String> createExercise(Exercise exercise) async {
    try {
      await SelfSyncDatabase.instance.createExercise(exercise);
    } catch (e) {
      return e.toString();
    }
    String result = await getExercises(exercise.workoutId);
    return result;
  }
}
