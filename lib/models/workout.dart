const String workoutTable = 'workout';

class WorkoutFields {
  static String id = 'id';
  static const String username = 'username';
  static const String title = 'title';
  static const String description = 'description';
  static const String done = 'done';
  static const String date = 'date';
  static const String exerciseTitles = 'exerciseTitles';
  static final List<String> allFields = [
    id,
    username,
    title,
    description,
    date,
    exerciseTitles
  ];
}

class Workout {
  int? id;
  final String username;
  String title;
  String description;
  bool done;
  final DateTime date;
  String exerciseTitles;

  Workout({
    this.id,
    required this.username,
    required this.title,
    required this.description,
    this.done = false,
    required this.date,
    required this.exerciseTitles,
  });

  Map<String, Object?> toJson() => {
        WorkoutFields.id: id,
        WorkoutFields.username: username,
        WorkoutFields.title: title,
        WorkoutFields.description: description,
        WorkoutFields.done: done ? 1 : 0,
        WorkoutFields.date: date.toIso8601String(),
        WorkoutFields.exerciseTitles: exerciseTitles,
      };

  static Workout fromJson(Map<String, Object?> json) => Workout(
        id: json[WorkoutFields.id] as int,
        username: json[WorkoutFields.username] as String,
        title: json[WorkoutFields.title] as String,
        description: json[WorkoutFields.description] as String,
        done: json[WorkoutFields.done] == 1 ? true : false,
        date: DateTime.parse(json[WorkoutFields.date] as String),
        exerciseTitles: json[WorkoutFields.exerciseTitles] as String,
      );

  toLowerCase() {}
}
