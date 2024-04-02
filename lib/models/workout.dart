final String workoutTable = 'workout';

class WorkoutFields {
  static final String id = 'id';
  static final String username = 'username';
  static final String title = 'title';
  static final String description = 'description';
  static final String done = 'done';
  static final String date = 'date';
  static final List<String> allFields = [
    id,
    username,
    title,
    description,
    date
  ];
}

class Workout {
  final int? id;
  final String username;
  String title;
  String description;
  bool done;
  final DateTime date;

  Workout({
    this.id,
    required this.username,
    required this.title,
    required this.description,
    this.done = false,
    required this.date,
  });

  Map<String, Object?> toJson() => {
        WorkoutFields.id: id,
        WorkoutFields.username: username,
        WorkoutFields.title: title,
        WorkoutFields.description: description,
        WorkoutFields.done: done ? 1 : 0,
        WorkoutFields.date: date.toIso8601String(),
      };

  static Workout fromJson(Map<String, Object?> json) => Workout(
        id: json[WorkoutFields.id] as int,
        username: json[WorkoutFields.username] as String,
        title: json[WorkoutFields.title] as String,
        description: json[WorkoutFields.description] as String,
        done: json[WorkoutFields.done] == 1 ? true : false,
        date: DateTime.parse(json[WorkoutFields.date] as String),
      );

  toLowerCase() {}
}
